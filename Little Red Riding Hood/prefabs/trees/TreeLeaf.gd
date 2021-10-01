extends Node2D


# Declare member variables here. Examples:
var top_offset = -50
var initial_position = Vector2()
export var time_anim = 4 
var flip = false


# Called when the node enters the scene tree for the first time.
func _ready():
    $Leaf.position.y = rand_range(-40, -70)
    initial_position = $Leaf.position
    run_tween()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_Tween_tween_completed(object, key):
    run_tween()


func run_tween():
    if flip:
        _run_tween($Leaf.position, initial_position)
    else:
        _run_tween($Leaf.position, initial_position + Vector2(rand_range(-10, 10), rand_range(-10, 10)))

func _run_tween(_in, _out):
    $Tween.interpolate_property($Leaf, 
                        "position", 
                        _in, 
                        _out, 
                        time_anim,
                        Tween.TRANS_CUBIC,
                        Tween.EASE_IN_OUT)
    $Tween.start()
