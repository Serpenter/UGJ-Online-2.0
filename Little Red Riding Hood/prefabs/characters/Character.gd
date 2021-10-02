extends KinematicBody2D

export var MOTION_SPEED = 5000


enum CHARACTER_TEAM {
    WORLD,
    PLAYER,
    PLAYER_ALLY,
    ENEMY,
    FLEEING
   }

export var team = CHARACTER_TEAM.PLAYER

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
    AI
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
onready var animation = $Animations/CharacterAnimation
var weapon_damage = 10
onready var equipment = {
    "rapier": {
        "can_attack":true,
        "attack_name": "SlashAdv",
        "animation": $Animations/CharacterAnimation,
        "weapon_damage": 10
    }
}

export var enemy_teams = [CHARACTER_TEAM.PLAYER, CHARACTER_TEAM.PLAYER_ALLY]

onready var detection_area = $DetectionArea
onready var event_area = $EventArea
onready var alert_area = $AlertArea
onready var pursue_area = $PursueArea

onready var attack_zone_up = $Animations/CharacterAnimation/AttackZone/AttackZoneUp
onready var attack_zone_down = $Animations/CharacterAnimation/AttackZone/AttackZoneDown
onready var attack_zone_left = $Animations/CharacterAnimation/AttackZone/AttackZoneLeft
onready var attack_zone_right = $Animations/CharacterAnimation/AttackZone/AttackZoneRight

onready var damage_zone_up = $Animations/CharacterAnimation/AttackZone/DamageZoneUp
onready var damage_zone_down = $Animations/CharacterAnimation/AttackZone/DamageZoneDown
onready var damage_zone_left = $Animations/CharacterAnimation/AttackZone/DamageZoneLeft
onready var damage_zone_right = $Animations/CharacterAnimation/AttackZone/DamageZoneRight


var char_control = CHARACTER_CONTROL.PLAYER
var use_mouse_look_dir = false
var use_mouse_attack_dir = true
export var current_state = CHARACTER_STATE.IDLE
var motion = Vector2()
var look_dir = Vector2()

export var health = 100
export var health_max = 100


# Called when the node enters the scene tree for the first time.
func _ready():
    damage_zone_up.connect("area_entered", self, "_on_damage_zone_entered")
    damage_zone_down.connect("area_entered", self, "_on_damage_zone_entered")
    damage_zone_left.connect("area_entered", self, "_on_damage_zone_entered")
    damage_zone_right.connect("area_entered", self, "_on_damage_zone_entered")
    
    if char_control == CHARACTER_CONTROL.PLAYER:
        enemy_teams = [CHARACTER_TEAM.ENEMY]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    idle_animation_check()
    process_player_input(delta)
    update_look_dir()
    resolve_movement_animation()
    

func reset_attack_zone_monitoring():
    attack_zone_up.monitoring = false
    attack_zone_down.monitoring = false
    attack_zone_left.monitoring = false
    attack_zone_right.monitoring = false
    
    attack_zone_up.monitoring = true
    attack_zone_down.monitoring = true
    attack_zone_left.monitoring = true
    attack_zone_right.monitoring = true
    
    
func receive_damage(damage):
    var blood_position = self.position
    blood_position.y -= 20
    get_tree().call_group("ParticleManager", "spawn_particle", "blood", blood_position)
    
func _on_damage_zone_entered(area):
    if area.is_in_group("character_area"):
        var owner = area.get_owner()

        if( owner.has_method("get_team") 
        and owner.get_team() in enemy_teams
        and owner.has_method("receive_damage") ):
            owner.receive_damage(weapon_damage)
    
func get_team():
    return team
    
func idle_animation_check():
    if not current_state in non_interactive_states:
        return
        
    reset_attack_zone_monitoring()

    var current_animation = animation.player.get_current_animation()
    if current_animation.empty():
        current_state = CHARACTER_STATE.IDLE
    

func begin_attack():

    if not can_attack:
        print("attempt to attack with can_attack=false")
        return
    
    var attack_dir
    
    if char_control == CHARACTER_CONTROL.PLAYER and use_mouse_attack_dir:
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
