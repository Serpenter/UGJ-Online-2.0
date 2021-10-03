extends Sprite

var has_been_activated = false


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_Activator_area_shape_entered(area_id, area, area_shape, local_shape):
    if area.name == "ActiveRange" and not has_been_activated:
        $PhrasePlayer.play_one_phrase()
        has_been_activated = true
#        has_been_activated = false
#        $"/root/GMainQuestState".quest_state = $"/root/GMainQuestState".QuestState.InProgress
