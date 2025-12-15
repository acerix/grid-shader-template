extends Control

@onready var c_material = $Canvas.material

# time since start
var time : float = 0

# canvas transforms
var c_position = Vector2()
var c_scale = 1
var c_rotation = 0

func _input(_event):
	# quit when Esc is pressed
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#var t = Time.get_unix_time_from_system()
	time += delta
	
	# 1 Hz for circular function
	var t = TAU * time
	
	#c_position.x = sin(t) / 4
	#c_position.y = cos(t) / 4
	#c_scale = exp(tan(t / 8))
	c_rotation =  PI / 4 * sin(t)
	
	c_material.set_shader_parameter("position", c_position)
	c_material.set_shader_parameter("scale", c_scale)
	c_material.set_shader_parameter("rotation", c_rotation)
