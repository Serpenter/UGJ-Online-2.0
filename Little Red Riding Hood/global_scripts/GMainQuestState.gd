extends Node
#Main Quest states

var character_node = null
var wolf_node = null

enum QuestState {
    NotTaken,
    Taken,
    InProgress,
    Finished,
    Failed,
    Darkened
}
var quest_state = QuestState.NotTaken setget _on_quest_change
signal quest_state_change(new_state)
signal game_over(quest_state)


enum MeatPie {
    NotTaken,
    Taken,
    Missed
}
var meat_pie = MeatPie.NotTaken

enum Wolf {
    No,
    Encounter,
    EatsGrandma,
    SecondEncounter,
    Killed
}
var wolf_state = Wolf.No

enum Woodcutter{
    No,
    Encounter,
    BeatsWolf,
    Killed
}
var woodcutter = Woodcutter.No

#end of main quest states

 
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
func _on_quest_change(new_quest_state):
    quest_state = new_quest_state
    emit_signal("quest_state_change", quest_state)
    match quest_state:
        QuestState.Taken:
            pass
        QuestState.InProgress:
            pass
        QuestState.Darkened:
            emit_signal("game_over", quest_state)
