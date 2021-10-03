extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var wolf = get_parent()
onready var quest_control = $"/root/GMainQuestState"
# Called when the node enters the scene tree for the first time.
func _ready():
    $"/root/GMainQuestState".wolf_node = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_Area2D_area_shape_entered(area_id, area, area_shape, local_shape):
    if area.name == "ActiveRange":
        
        var quest_state = quest_control.quest_state
        if quest_state == quest_control.QuestState.NotTaken:
            $PhrasePlayer.set_phrases(["I'm hungry", "You don't have food", "So, you are the food!"])
            $PhrasePlayer.autoplay_all = true
            $PhrasePlayer.play_one_phrase()
            wolf.char_control = 1
            wolf.MOTION_SPEED = 10000
        if quest_state == quest_control.QuestState.InProgress:
            $PhrasePlayer.set_phrases(["Where are you going?", 
                                        "Does she live far off?", 
                                        "Well, and I'll go and see her too.",
                                        "I'll go this way and go you that, and we shall see who will be there first."])
            $PhrasePlayer.autoplay_all = true
            $PhrasePlayer.play_one_phrase()
            quest_control.character_node.MOTION_SPEED = 0
            var char_player = quest_control.character_node.get_node("PhrasePlayer")
            char_player.set_phrases(["I am going to see my grandmother and carry her a cake and a little pot of butter from my mother.", 
                                     "Oh I say, it is beyond that mill you see there, at the first house in the village."])
            char_player.play_one_phrase()
            $UnboundTimer.start()


func _on_UnboundTimer_timeout():
    quest_control.character_node.MOTION_SPEED = 8500
