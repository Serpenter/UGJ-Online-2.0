extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var initial_saturation = 1.1
# export onready var saturation = initial_saturation setget _set_saturation
export var new_level_saturation = 1.1
export var change_time = 1
# Called when the node enters the scene tree for the first time.
func _ready():
    $"/root/GGrimdarkControl".connect("level_changed", self, "_on_grimdark_level_changed")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
func _on_grimdark_level_changed(new_level):
    material.set_shader_param("saturation", initial_saturation - new_level)
#    new_level_saturation = new_level
#    $Tween.interpolate_property(self, 
#                                "saturation", 
#                                saturation, 
#                                new_level, 
#                                change_time,
#                                Tween.TRANS_CUBIC,
#                                Tween.EASE_IN_OUT)
#    $Tween.start()
#
#
#func _set_saturation(new_saturation):
#    material.set_shader_param("saturation", new_saturation)
#
#
#
#func _on_Tween_tween_all_completed():
#    saturation = new_level_saturation
