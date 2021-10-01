tool
extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum Roof {Red, Green, Blue}
export(Roof) var roof = Roof.Red setget set_roof 

# Called when the node enters the scene tree for the first time.
func _ready():
    pass

func set_roof(new_val):
    $House/RoofBlue.hide()
    $House/RoofGreen.hide()
    roof = new_val
    if roof == Roof.Red:
        $House/RoofBlue.hide()
        $House/RoofGreen.hide()
    elif roof == Roof.Green:
        $House/RoofBlue.hide()
        $House/RoofGreen.show()
    elif roof == Roof.Blue:
        $House/RoofBlue.show()
        $House/RoofGreen.hide()

