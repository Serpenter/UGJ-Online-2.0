extends Node
#Main Quest states

enum QuestState {
    NotTaken,
    Taken,
    InProgress,
    Finished
}
var quest_state = QuestState.NotTaken

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
