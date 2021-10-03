extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.



func _on_Area2D3_area_shape_entered(area_id, area, area_shape, local_shape):
    if area.name == "ActiveRange":
        area.get_parent().equip_weapon("waraxe")

