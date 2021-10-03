extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    $"/root/GGrimdarkControl".connect("level_changed", self, "_on_grimdark_level_changed")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
func _on_grimdark_level_changed(new_level):
    pass
