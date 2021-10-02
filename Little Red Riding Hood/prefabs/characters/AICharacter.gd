extends "res://prefabs/characters/Character.gd"


enum AI_STATE {
    WAIT,
    FOLLOW_TARGET,
    ATTACK_TARGET,
    FLEE_FROM_TARGET
}


var ai_state = AI_STATE.WAIT
var attack_everything = false

# Called when the node enters the scene tree for the first time.
func _ready():
    char_control = CHARACTER_CONTROL.AI
    team = CHARACTER_TEAM.ENEMY
#    FOR DEBUG, LATER SET IN EDITOR
    detection_area.connect("area_entered", self, "_on_detection_area_entered")
    attack_zone_up.connect("area_entered", self, "_on_attack_zone_entered", [Vector2.UP])
    attack_zone_down.connect("area_entered", self, "_on_attack_zone_entered", [Vector2.DOWN])
    attack_zone_left.connect("area_entered", self, "_on_attack_zone_entered", [Vector2.LEFT])
    attack_zone_right.connect("area_entered", self, "_on_attack_zone_entered", [Vector2.RIGHT])
    enemy_teams = [CHARACTER_TEAM.PLAYER, CHARACTER_TEAM.PLAYER_ALLY]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    process_ai_actions(delta)
    
func _on_attack_zone_entered(area, zone_direction):
    if char_control != CHARACTER_CONTROL.AI:
        return

    if ai_state != AI_STATE.ATTACK_TARGET:
        return
    
    if not target or not target.get_team() in enemy_teams:
        target = null
        ai_state = AI_STATE.WAIT
        return
        
    if not current_state == CHARACTER_STATE.WALK and not current_state == CHARACTER_STATE.IDLE:
        return
        
    if area.is_in_group("character_area"):
        var owner = area.get_owner()
        if target != owner:
            return
    else:
        return

        
    look_dir = zone_direction
    motion = zone_direction
    begin_attack()
    

func _on_detection_area_entered(area):
    if not target == null:
        return
        
    if not ai_state == AI_STATE.WAIT:
        return
 
    if not attack_everything:
        if area.is_in_group("character_area"):
            var owner = area.get_owner()

            if owner.has_method("get_team") and owner.get_team() in enemy_teams:
                target = owner
                ai_state = AI_STATE.ATTACK_TARGET
            
func process_ai_actions(_delta):
    if char_control != CHARACTER_CONTROL.AI:
        return
    if ai_state == AI_STATE.WAIT:
        return
        
    if ai_state == AI_STATE.FOLLOW_TARGET or ai_state == AI_STATE.ATTACK_TARGET:
        resolve_follow_target(_delta)
        
#    if ai_state == AI_STATE.ATTACK_TARGET:
#        resolve_ai_attack_opportunity()
#
#func resolve_ai_attack_opportunity():
#    pass

func resolve_follow_target(_delta):
    if char_control != CHARACTER_CONTROL.AI:
        return
    motion = Vector2()
    
    if not current_state == CHARACTER_STATE.WALK and not current_state == CHARACTER_STATE.IDLE:
        return
        
    var target_vector = target.global_position - global_position
    motion = target_vector.normalized() * MOTION_SPEED * _delta
