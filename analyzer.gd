extends AudioStreamPlayer

var spectrum: AudioEffectSpectrumAnalyzerInstance

func _ready() -> void:
	var idx = AudioServer.get_bus_index(&"Input")
	spectrum = AudioServer.get_bus_effect_instance(idx, 0)
	
func _process(_delta: float) -> void:
	var magnitude = spectrum.get_magnitude_for_frequency_range(0, 11050)[0]
	$"../Canvas".material.set_shader_parameter("rotation", magnitude)
