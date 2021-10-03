extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var grimdark_level = 0.0 setget _on_grimdark_change

signal level_changed(level)

func _ready():
    pass # Replace with function body.


func increase_grimdark_level():
    grimdark_level = grimdark_level + 0.02
    if grimdark_level >= 1.0:
        pass #game over


func _on_grimdark_change(new_level):
    grimdark_level = new_level
    emit_signal("level_changed", new_level)
