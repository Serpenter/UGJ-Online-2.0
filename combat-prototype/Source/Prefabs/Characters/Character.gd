extends RigidBody2D

onready var animation_player = $AnimationPlayer

onready var sprite_body = $SpriteBody
onready var sprite_boots = $SpriteBoots
onready var sprite_legs = $SpriteLegs
onready var sprite_torso = $SpriteTorso
onready var sprite_belt = $SpriteBelt
onready var sprite_head = $SpriteHead
onready var sprite_weapon = $SpriteWeapon

enum CHARACTER_STATE {
	IDLE,
	WALK,
	ATTACK,
	DAMAGED,
	DYING
}

const vector_to_direction = {
					Vector2(0,-1) : "Up",
					Vector2(-1,0) : "Left",
					Vector2(1,0) : "Right",
					Vector2(0,1) : "Down",
					Vector2(0,0) :"Down"
					}
					
const state_to_name = {
	CHARACTER_STATE.IDLE: "Idle",
	CHARACTER_STATE.WALK: "Walk",
	CHARACTER_STATE.ATTACK: "Attack",
	CHARACTER_STATE.DAMAGED: "Damaged",
	CHARACTER_STATE.DYING: "Dying"
}

var current_state
var look_vector = Vector2()
var move_vector = Vector2()
var old_move_vector = Vector2()

var speed_modifier = 1.0
var max_move_speed = 150
var move_force = 150
var move_impulse = Vector2()

var health = 100
var max_health = 100

var forced_velocity = true

# Called when the node enters the scene tree for the first time.
func _ready():
	current_state = CHARACTER_STATE.IDLE
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	input_to_move_vector()
	resolve_move_state()
	resolve_move_animation()
	calculate_move_impulse(delta)


func _integrate_forces(state):
	if forced_velocity:
		return

	if current_state == CHARACTER_STATE.WALK:
		apply_central_impulse(move_impulse)      
		if state.linear_velocity.length()>max_move_speed:
				state.linear_velocity=state.linear_velocity.normalized()*max_move_speed
	elif current_state == CHARACTER_STATE.IDLE:
		set_linear_velocity(Vector2())
		
	
	
func resolve_move_state():
	if not can_walk():
		return

	if move_vector == Vector2():
		current_state = CHARACTER_STATE.IDLE
	else:
		current_state = CHARACTER_STATE.WALK  
		

func resolve_move_animation():
	var approximate_direction
	
	if current_state == CHARACTER_STATE.WALK:
		approximate_direction = approximate_vector_direction(move_vector)
	else:
		approximate_direction = approximate_vector_direction(look_vector)
		
	var animation_name = state_to_name.get(current_state)
	animation_name += vector_to_direction.get(approximate_direction)
	
	animation_player.play(animation_name)
	

func approximate_vector_direction(vector):
	
		if vector == Vector2.ZERO:
			return Vector2.ZERO
			
		if (abs(vector.x) > abs(vector.y)):
			return Vector2(sign(vector.x), 0)
			
		return Vector2(0, sign(vector.y))


func can_walk():
	var result = current_state == CHARACTER_STATE.IDLE or current_state == CHARACTER_STATE.WALK
	return result
	
	

func input_to_move_vector():
	old_move_vector = move_vector
	move_vector = Vector2()
	
	if not can_walk():
		return
	
	if Input.is_action_pressed("move_up"):
		move_vector.y -= 1
	if Input.is_action_pressed("move_down"):
		move_vector.y += 1
	if Input.is_action_pressed("move_left"):
		move_vector.x -= 1
	if Input.is_action_pressed("move_right"):
		move_vector.x += 1
	
	move_vector = move_vector.normalized()
	
	if move_vector != Vector2(0,0):
		look_vector = move_vector
		
func calculate_move_impulse(delta):
	if forced_velocity:
		print(move_vector)
		set_axis_velocity(move_vector * max_move_speed)
	else:
		move_impulse = move_force * move_vector * delta
		

