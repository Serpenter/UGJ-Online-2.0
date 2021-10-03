tool
extends Node2D


onready var attack_zone_up = $AttackZone/AttackZoneUp
onready var attack_zone_down = $AttackZone/AttackZoneDown
onready var attack_zone_left = $AttackZone/AttackZoneLeft
onready var attack_zone_right = $AttackZone/AttackZoneRight

onready var damage_zone_up = $AttackZone/DamageZoneUp
onready var damage_zone_down = $AttackZone/DamageZoneDown
onready var damage_zone_left = $AttackZone/DamageZoneLeft
onready var damage_zone_right = $AttackZone/DamageZoneRight

onready var damage_zone_up2 = $AttackZone/DamageZoneUp2
onready var damage_zone_down2 = $AttackZone/DamageZoneDown2
onready var damage_zone_left2 = $AttackZone/DamageZoneLeft2
onready var damage_zone_right2 = $AttackZone/DamageZoneRight2

onready var player = $AnimationPlayer
export(Texture) var sprite_reg setget set_sprute_reg
export(Texture) var sprite_adv setget set_sprite_adv
#export(Texture) var texture_reg = $Sprite.texture
#export(Texture) var texture_adv = $AdvSlashSprite.texture

func set_sprute_reg(tex):
    sprite_reg = tex
    if Engine.editor_hint:
        get_node("Sprite").texture = sprite_reg
        
func set_sprite_adv(tex):
    sprite_adv = tex
    if Engine.editor_hint:
        get_node("AdvSlashSprite").texture = sprite_adv
        

func _ready():
    get_node("Sprite").texture = sprite_reg
    get_node("AdvSlashSprite").texture = sprite_adv


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
