extends Node2D


onready var player = $AnimationPlayer

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
export var sit_at_start = true
export var run_away_dir = Vector2.RIGHT
export var run_away_dist = 1000

func just_sit():
    var animation_name = "Idle" + get_direction_str(look_dir)
    player.play(animation_name)
    current_state = RACOON_STATE.IDLE

func fly_and_die(start_pos, end_pos, dir):
    look_dir = dir
    var animation_name = "Walk" + get_direction_str(look_dir)
    player.play(animation_name)
    current_state = RACOON_STATE.WALK
    position = start_pos
    target_position = end_pos

# Called when the node enters the scene tree for the first time.
func _ready():
    if sit_at_start:
        just_sit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if current_state != RACOON_STATE.WALK:
        return
    
    var position_diff = target_position - position
    if position_diff.length() > speed * delta:
        position += position_diff.normalized() * delta * speed
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

func run_away():
    var end_pos = position + run_away_dist * run_away_dir.normalized()
    fly_and_die(position, end_pos, run_away_dir)

func _on_Area2D_area_entered(area):
    if current_state == RACOON_STATE.WALK:
        return

    if area.is_in_group("character_area"):
        run_away()
