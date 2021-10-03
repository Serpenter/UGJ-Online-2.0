extends Node2D

export(Array, String) var phrases : Array = [] setget set_phrases
export var autoplay_all = true
export var visible_time = 4
export var autoplay_interval = 2 setget set_autoplay
export var offset = Vector2(16, -64)


var current_phrase_index = -1
var has_finished = false

signal plot_finished

func _ready():
    $Label.visible = false


func say_phrase(phrase):
    var new_label = $Label.duplicate()
    new_label.visible = true
    add_child(new_label)
    new_label.text = phrase
    run_tween(new_label)


func play_one_phrase():
    if autoplay_all:
        $Autoplay.start()
    if current_phrase_index != -1 and current_phrase_index < phrases.size():
        var new_label = $Label.duplicate()
        new_label.visible = true
        add_child(new_label)
        new_label.text = phrases[current_phrase_index]
        current_phrase_index += 1
        if current_phrase_index >= phrases.size():
            current_phrase_index = -1
            has_finished = true
            emit_signal("plot_finished")
        run_tween(new_label)


func set_phrases(_phrases):
    phrases = _phrases
    has_finished = false
    if phrases.size() > 0:
        current_phrase_index = 0
    else:
        current_phrase_index = -1


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
    if get_node(object.name):
        remove_child(object)
        object.queue_free()


func set_autoplay(_interval):
    autoplay_interval = _interval
    $Autoplay.wait_time = autoplay_interval


func _on_Autoplay_timeout():
    play_one_phrase()
    if autoplay_all:
        $Autoplay.start()
