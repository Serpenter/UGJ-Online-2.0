tool
extends Node2D


export var phrase_enter = ""
export var phrase_exit = ""

export var is_active = false
export var one_shot = false
export var say_delay = 1
export var radius = 64 setget _on_rad_set
export var is_affect_grimdark = true
export var grimdark_value = 0.03

var is_shot = false
var is_said = false


func _ready():
    $SayTimer.wait_time = say_delay


func _on_Area2D_area_shape_entered(area_id, area, area_shape, local_shape):
    if area.name == "ActiveRange" and not is_said and is_active and not is_shot:
        $SayTimer.start()
        if not phrase_enter.empty():
            $PhrasePlayer.say_phrase(phrase_enter)
        is_said = true
        if is_affect_grimdark:
            $"/root/GGrimdarkControl".grimdark_level = $"/root/GGrimdarkControl".grimdark_level + grimdark_value 


func _on_Area2D_area_shape_exited(area_id, area, area_shape, local_shape):
    if area.name == "ActiveRange" and not is_said and is_active and not is_shot:
        $SayTimer.start()
        if not phrase_exit.empty():
            $PhrasePlayer.say_phrase(phrase_exit)
        is_said = true
        if one_shot:
            is_shot = true

func _on_SayTimer_timeout():
    is_said = false
    $SayTimer.wait_time = say_delay


func _on_rad_set(new_rad):
    radius = new_rad
    $Area2D/CollisionShape2D.shape.radius = new_rad
