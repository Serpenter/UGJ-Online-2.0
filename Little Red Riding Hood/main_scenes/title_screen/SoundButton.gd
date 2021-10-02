extends CheckButton

func _ready():
	pass # Replace with function body.

func _on_CheckButton_toggled(button_pressed):
	if button_pressed:
		print_debug('ON')
	else:
		print_debug('OFF')
