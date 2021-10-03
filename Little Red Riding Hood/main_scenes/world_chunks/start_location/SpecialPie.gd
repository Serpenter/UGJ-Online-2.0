extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var is_char_nearby = false
onready var quest_state = $"/root/GMainQuestState"

# Called when the node enters the scene tree for the first time.
func _ready():
    $"/root/GMainQuestState".connect("quest_state_change", self, "_handle_quest_change")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_Area2D_area_shape_entered(area_id, area, area_shape, local_shape):
    if area.name == "ActiveRange":
        is_char_nearby = true
        if quest_state.quest_state == quest_state.QuestState.Taken:
            start_journey()


func _on_Area2D_area_shape_exited(area_id, area, area_shape, local_shape):
    if area.name == "ActiveRange":
        is_char_nearby = false


func _handle_quest_change(new_state):
    if new_state == quest_state.QuestState.Taken and is_char_nearby:
        start_journey()


func start_journey():
    quest_state.quest_state = quest_state.QuestState.InProgress
    $PhrasePlayer.play_one_phrase()
    $VanishTimeout.start()
    $Particles2D.emitting = true
    $Tween.interpolate_property($Sprite, 
                                "modulate", 
                                Color(1,1,1,1), 
                                Color(1,1,1,0), 
                                2,
                                Tween.TRANS_CUBIC,
                                Tween.EASE_IN_OUT)
    $Tween.start()

func _on_VanishTimeout_timeout():
    queue_free()
