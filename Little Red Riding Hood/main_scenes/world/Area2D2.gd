extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.



func _on_Area2D2_area_shape_entered(area_id, area, area_shape, local_shape):
    if area.name == "ActiveRange":
        get_parent().get_node("Raccoon2").run_away()
