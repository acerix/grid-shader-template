extends AudioStreamPlayer

# @todo split the bands to 12 notes/ octave -- show the "color" of the loudest note detected

const FREQ_MIN = 32
const FREQ_MAX = 32768
const NUM_BANDS = 8

func get_frequency_bands() -> Array:
	var bands = []
	var start = log(FREQ_MIN)
	var width = (log(FREQ_MAX) - start) / NUM_BANDS
	for i in range(NUM_BANDS):
		var end = start + width
		var from_hz = exp(start)
		var to_hz = exp(end)
		#print("Band {}: {}-{}".format([i, roundi(from_hz), roundi(to_hz)], "{}"))
		bands.append([from_hz, to_hz])
		start = end
	return bands
	
var FREQ_BANDS = get_frequency_bands()

var spectrum_analyzer: AudioEffectSpectrumAnalyzerInstance

func _ready() -> void:
	var input_bus_idx = AudioServer.get_bus_index(&"Input")
	spectrum_analyzer = AudioServer.get_bus_effect_instance(input_bus_idx, 0)
	#$"../Canvas".material.set_shader_parameter("num_bands", NUM_BANDS)
	
func _process(_delta: float) -> void:
	#var magnitude = spectrum_analyzer.get_magnitude_for_frequency_range(0, 11050).length()
	#$"../Canvas".material.set_shader_parameter("rotation", magnitude)
	
	#var band_values = []
	#for band in FREQ_BANDS:
	var top_band = 0
	var top_magnitude = 0
	for i in range(NUM_BANDS):
		var hz = FREQ_BANDS[i]
		var magnitude = spectrum_analyzer.get_magnitude_for_frequency_range(hz[0], hz[1]).length()
		if (magnitude > top_magnitude):
			top_band = i
			top_magnitude = magnitude
		#band_values.append(magnitude)
		#print("band_{0} ".format([i]), magnitude)
		#$"../Canvas".material.set_shader_parameter("band_{0}".format([i]), magnitude)
	
	#print('Band {0} = {1}'.format([top_band, top_magnitude]))
	$"../Canvas".material.set_shader_parameter("band_freq", top_band / float(NUM_BANDS))
	$"../Canvas".material.set_shader_parameter("band_value", top_magnitude * 16)
