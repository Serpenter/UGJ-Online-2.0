tool
extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum Roof {Red, Green, Blue}
export(Roof) var roof = Roof.Red setget set_roof 

# Called when the node enters the scene tree for the first time.
func _ready():
    change_color()


func set_roof(new_val):
    roof = new_val
    change_color()


func change_color():
    $House/RoofBlue.hide()
    $House/RoofGreen.hide()
    if roof == Roof.Red:
        $House/RoofBlue.hide()
        $House/RoofGreen.hide()
    elif roof == Roof.Green:
        $House/RoofBlue.hide()
        $House/RoofGreen.show()
    elif roof == Roof.Blue:
        $House/RoofBlue.show()
        $House/RoofGreen.hide()

