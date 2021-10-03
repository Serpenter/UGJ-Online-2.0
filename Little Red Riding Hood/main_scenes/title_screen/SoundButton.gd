extends CheckButton

func _ready():
    pressed = $"/root/GOptions".current_sound_toggle

func _on_CheckButton_toggled(button_pressed):
    if button_pressed:
        AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0 )
        $"/root/GOptions".current_sound_toggle = true
        print_debug('ON')
    else:
        AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -80 )
        $"/root/GOptions".current_sound_toggle = false
        print_debug('OFF')
