extends Control

onready var texture_over = $TextureOver
onready var texture_under = $TextureUnder

export var always_invisible = false

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func set_always_invisible(is_invisible):
    always_invisible = is_invisible

    if always_invisible:
        visible = false
    
    update_visibility()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func update_visibility():
    if not always_invisible:
        visible = !(texture_over.value == texture_over.max_value 
        or texture_over.value <= 0)


func _on_Character_health_changed(health):
    texture_over.value = health
    update_visibility()


func _on_Character_max_health_changed(max_health):
    texture_over.max_value = max_health

    update_visibility()
        
