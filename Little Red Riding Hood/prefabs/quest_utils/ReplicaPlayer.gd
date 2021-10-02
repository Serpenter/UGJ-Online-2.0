extends Node2D

export(Array, String) var replicas : Array = [] setget set_replica
export var autoplay_all = true
export var visible_time = 4
export var autoplay_interval = 2 setget set_autoplay
export var offset = Vector2(16, -64)


var current_replica_index = -1


func _ready():
    $Label.visible = false


func play_one_replica():
    if autoplay_all:
        $Autoplay.start()
    if current_replica_index != -1 and current_replica_index < replicas.size():
        var new_label = $Label.duplicate()
        new_label.visible = true
        add_child(new_label)
        new_label.text = replicas[current_replica_index]
        current_replica_index += 1
        if current_replica_index >= replicas.size():
            current_replica_index == -1
        run_tween(new_label)


func set_replica(_replicas):
    replicas = _replicas
    if replicas.size() > 0:
        current_replica_index = 0
    else:
        current_replica_index = -1


func run_tween(label):

    label.set_position(Vector2())
    label.modulate = Color(1,1,1,1)

    $Tween.interpolate_property(label, 
                                "rect_position", 
                                Vector2(), 
                                offset, 
                                visible_time,
                                Tween.TRANS_CUBIC,
                                Tween.EASE_IN_OUT)
    $Tween.interpolate_property(label, 
                                "modulate", 
                                Color(1,1,1,1), 
                                Color(1,1,1,0), 
                                visible_time,
                                Tween.TRANS_CUBIC,
                                Tween.EASE_IN_OUT)
    $Tween.start()


func _on_Tween_tween_completed(object, key):
    remove_child(object)
    object.queue_free()


func set_autoplay(_interval):
    autoplay_interval = _interval
    $Autoplay.wait_time = autoplay_interval


func _on_Autoplay_timeout():
    play_one_replica()
    if autoplay_all:
        $Autoplay.start()
