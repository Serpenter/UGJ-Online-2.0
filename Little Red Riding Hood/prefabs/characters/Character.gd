extends KinematicBody2D

export var MOTION_SPEED = 5000
export var team = 1

enum CHARACTER_STATE {
	IDLE,
	WALK,
	ATTACK
}

const non_interactive_states = [
	CHARACTER_STATE.ATTACK
]

enum CHARACTER_CONTROL {
	PLAYER,
	AI_IDLE,
	AI_ATTACK,
	AI_KEEP_DISTANCE
	AI_FLEE
}

const dir_to_str = {
					Vector2(0,-1) : "Up",
					Vector2(-1,0) : "Left",
					Vector2(1,0) : "Right",
					Vector2(0,1) : "Down",
					Vector2(0,0) :"Down"
					}

var can_attack = true
var attack_name = "SlashAdv"
onready var animation = $Animations/LRRHAnimationDagger

onready var equipment = {
	"unarmed": {
		"can_attack":true,
		"attack_name": "SlashAdv",
		"animation": $Animations/LRRHAnimationDagger
	}
}

var is_controlled_by_player = true
var char_control = CHARACTER_CONTROL.PLAYER
var use_mouse_look_dir = false
var use_mouse_attack_dir = true
export var current_state = CHARACTER_STATE.IDLE
var motion = Vector2()
var look_dir = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	idle_animation_check()
	process_player_input(delta)
	update_look_dir()
	resolve_movement_animation()
	
	
func idle_animation_check():
	if not current_state in non_interactive_states:
		return

	var current_animation = animation.player.get_current_animation()
	if current_animation.empty():
		current_state = CHARACTER_STATE.IDLE
	

func begin_attack():
	if not can_attack:
		print("attempt to attack with can_attack=false")
		return
	
	var attack_dir
	
	if use_mouse_attack_dir:
		attack_dir = get_global_mouse_position() - get_global_position()
	else:
		update_look_dir()
		attack_dir = look_dir
		
	var animation_name = attack_name + get_direction_str(look_dir)
	animation.player.play(animation_name)
	current_state = CHARACTER_STATE.ATTACK
	
	
func _physics_process(_delta):
	move_and_slide(motion)
	motion = Vector2.ZERO

	
func update_look_dir():
	if not motion == Vector2.ZERO:
		look_dir = motion.normalized()
		return
		
	if not char_control == CHARACTER_CONTROL.PLAYER or not use_mouse_look_dir:
		return
	
	look_dir = get_global_mouse_position() - get_global_position()
	look_dir = look_dir.normalized()
	
	
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
	
	
func resolve_movement_animation():
	if (not current_state == CHARACTER_STATE.IDLE 
	and not current_state == CHARACTER_STATE.WALK):
		return

	var animation_name

	if motion == Vector2.ZERO:
		current_state = CHARACTER_STATE.IDLE
		animation_name = "Idle"
	else:
		current_state = CHARACTER_STATE.WALK
		animation_name = "Walk"
	
	animation_name += get_direction_str(look_dir)
	animation.player.play(animation_name)
	
	
func process_player_input(_delta):
	if not char_control == CHARACTER_CONTROL.PLAYER:
		return
		
	if current_state in non_interactive_states:
		return
		
	motion.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	motion.y =  Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	if not motion == Vector2.ZERO:
		motion = motion.normalized() * MOTION_SPEED * _delta
		
	if Input.is_action_pressed("attack") and can_attack:
		begin_attack()
