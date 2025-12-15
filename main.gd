extends Control

func _input(_event):
	# Quit when Esc is pressed
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
