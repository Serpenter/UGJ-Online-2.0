extends KinematicBody2D

export var MOTION_SPEED = 200

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.




# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _physics_process(_delta):
    var motion = Vector2()
    
    motion.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
    motion.y =  Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

    motion = motion.normalized() * MOTION_SPEED
    #warning-ignore:return_value_discarded
    move_and_slide(motion)

func is_character():
    return true
