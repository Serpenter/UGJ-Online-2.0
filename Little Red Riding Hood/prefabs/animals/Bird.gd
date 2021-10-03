tool
extends Node2D

onready var detection_area = $DetectionArea 
onready var player = $AnimationPlayer
export(Texture) var sprite_reg setget set_sprute_reg

enum BIRD_STATE {
    SIT,
    FLY
   }

const dir_to_str = {
                    Vector2(0,-1) : "Up",
                    Vector2(-1,0) : "Left",
                    Vector2(1,0) : "Right",
                    Vector2(0,1) : "Down",
                    Vector2(0,0) :"Down"
                    }

export var current_state = BIRD_STATE.SIT
export var look_dir = Vector2.RIGHT

export var speed = 1000
export var move_direction = Vector2.RIGHT
var target_position = Vector2.ZERO

export var fly_away_on_detection = true
export var fly_away_in_random_direction = true
export var preferred_fly_direction = Vector2.UP
export var fly_distance = 1000
export var start_sitting = true
export var random_look_dir = true

func just_sit(dir):
    look_dir = dir
    var animation_name = "Walk" + get_direction_str(look_dir)
    player.play(animation_name)
    current_state = BIRD_STATE.SIT

func fly_and_die(start_pos, end_pos, dir):
    look_dir = dir
    var animation_name = "Fly" + get_direction_str(look_dir)
    player.play(animation_name)
    current_state = BIRD_STATE.FLY
    position = start_pos
    target_position = end_pos

func set_sprute_reg(tex):
    sprite_reg = tex
    if Engine.editor_hint:
        get_node("Sprite").texture = sprite_reg

# Called when the node enters the scene tree for the first time.
func _ready():
    get_node("Sprite").texture = sprite_reg
    detection_area.connect("area_entered", self, "_on_detection_area_entered")
    if start_sitting:
        just_sit(look_dir)
    
    if random_look_dir:
        look_dir = get_random_dir()
        
        
func get_random_dir():
    var directions = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
    return directions[randi() % directions.size()]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if current_state != BIRD_STATE.FLY:
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
    
    
func fly_away():
    look_dir = preferred_fly_direction

    if fly_away_in_random_direction:
        look_dir = get_random_dir()
        
    
    target_position = position + look_dir.normalized() * fly_distance
    fly_and_die(position, target_position, look_dir)
    
func _on_detection_area_entered(area):
    if current_state == BIRD_STATE.FLY:
        return

    if area.is_in_group("character_area"):
        fly_away()
        
        
            
