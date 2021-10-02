tool
extends Node2D


onready var player = $AnimationPlayer
export(Texture) var sprite_reg setget set_sprute_reg

enum RACOON_STATE {
    IDLE,
    WALK
   }

const dir_to_str = {
                    Vector2(0,-1) : "Up",
                    Vector2(-1,0) : "Left",
                    Vector2(1,0) : "Right",
                    Vector2(0,1) : "Down",
                    Vector2(0,0) :"Down"
                    }

export var current_state = RACOON_STATE.IDLE
export var look_dir = Vector2.RIGHT

export var speed = 100
export var move_direction = Vector2.RIGHT
var target_position = Vector2.ZERO


func just_sit(dir):
    look_dir = dir
    var animation_name = "Idle" + get_direction_str(look_dir)
    player.play(animation_name)
    current_state = RACOON_STATE.IDLE

func fly_and_die(start_pos, end_pos, dir):
    look_dir = dir
    var animation_name = "Move" + get_direction_str(look_dir)
    player.play(animation_name)
    current_state = RACOON_STATE.WALK
    position = start_pos
    target_position = end_pos

func set_sprute_reg(tex):
    sprite_reg = tex
    if Engine.editor_hint:
        get_node("Sprite").texture = sprite_reg

# Called when the node enters the scene tree for the first time.
func _ready():
    get_node("Sprite").texture = sprite_reg



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if current_state != RACOON_STATE.MOVE:
        return
    
    var position_diff = target_position - position
    if abs(position_diff) > speed * delta:
        position += position_diff.normalized() * delta
    else:
        position = target_position
        die()
        
func die():
    queue_free()

func get_direction_str(direction):
    var approx_dir
    
    if direction == Vector2.ZERO:
        approx_dir = Vector2.ZERO
    elif (abs(direction.x) >= abs(direction.y)):
        approx_dir = Vector2(sign(direction.x), 0)
    else:
        approx_dir = Vector2(0, sign(direction.y))
        
    var result = dir_to_str.get(approx_dir)
    return result
