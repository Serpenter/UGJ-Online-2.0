extends Node2D


# Declare member variables here. Examples:
var offset_range = Vector2(-40, -70)
var move_range_y = Vector2(-5, 5)
var move_range_x = Vector2(-10, 10)
var initial_position = Vector2()
export var time_anim = 4 
var flip = false


# Called when the node enters the scene tree for the first time.
func _ready():
    scale = scale * rand_range(0.8, 1.1)
    $Leaf.position.y = rand_range(offset_range.x, offset_range.y)
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
        _run_tween($Leaf.position, initial_position + Vector2(rand_range(move_range_x.x, move_range_x.y), rand_range(move_range_y.x, move_range_y.y)))

func _run_tween(_in, _out):
    $Tween.interpolate_property($Leaf, 
                        "position", 
                        _in, 
                        _out, 
                        time_anim,
                        Tween.TRANS_CUBIC,
                        Tween.EASE_IN_OUT)
    $Tween.start()
