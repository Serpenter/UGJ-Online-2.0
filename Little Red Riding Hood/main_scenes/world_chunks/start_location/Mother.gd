extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var hello_interval = 1

var bool_said_hello = false
var has_been_activated

# Called when the node enters the scene tree for the first time.
func _ready():
    $SayTimer.wait_time = hello_interval
    $PhrasePlayer.connect("plot_finished", self, "_on_finished_plot")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_Area2D_area_shape_entered(area_id, area, area_shape, local_shape):
    if area.name == "ActiveRange":
        if not has_been_activated:
            $PhrasePlayer.play_one_phrase()
            return
        if not bool_said_hello:
            $SayTimer.start()
            $PhrasePlayer.say_phrase("Hello!")
            bool_said_hello = true


func _on_Area2D_area_shape_exited(area_id, area, area_shape, local_shape):    
    if area and area.name == "ActiveRange" and not bool_said_hello:
        $SayTimer.start()
        $PhrasePlayer.say_phrase("Bye!")
        bool_said_hello = true


func _on_SayTimer_timeout():
    bool_said_hello = false
    $SayTimer.wait_time = hello_interval


func _on_finished_plot():
    $"/root/GMainQuestState".quest_state = $"/root/GMainQuestState".QuestState.Taken 
    has_been_activated = true
