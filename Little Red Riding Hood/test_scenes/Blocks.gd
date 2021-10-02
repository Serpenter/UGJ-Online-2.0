tool
extends YSort



export(bool) var rerun = false setget process_children
export(int) var columns = 6
export(int) var width = 832
export(int) var height = 384

# Called when the node enters the scene tree for the first time.
func _ready():
    var game_objects = get_parent().get_node("GameObjects")
    if Engine.editor_hint:
        for child in get_children():
            child.get_node("Scene").visible = true
    else:
        for child in get_children():
#            for grandson in child.get_node("Scene/GameObjects").get_children():
#                game_objects.add_child(grandson)
            if child.get_node("ActiveArea").overlaps_area(get_parent().get_node("GameObjects/Character/ActiveRange")):
                child.get_node("Scene").visible = true
            else:
                child.get_node("Scene").visible = false



func process_children(newVal):
    if Engine.editor_hint:
        print("rearranging children...")
        var children = get_children()
        var ch_count = get_child_count()

        for i in range(ch_count):
            children[i].global_position.x = (i % columns) * width
            children[i].global_position.y = (i / columns) * height

