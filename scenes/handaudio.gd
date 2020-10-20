extends AudioStreamPlayer3D

onready var handbody = get_parent().get_node('HandBody')

 # Keep the number of samples to mix low, GDScript is not super fast.
# var sample_hz = 44100.0
var sample_hz = 22050.0
# var sample_hz = 1000.0
var pulse_hz = 100.0
var phase = 0.0
var threads = []

var playback: AudioStreamPlayback = null # Actual playback stream, assigned in _ready().

func _fill_buffer():
	var increment = pulse_hz / sample_hz

	var to_fill = playback.get_frames_available()
	while to_fill > 0:
		playback.push_frame(Vector2.ONE * sin(phase * TAU)) # Audio frames are stereo.
		phase = fmod(phase + increment, 1.0)
		to_fill -= 1

func _process(_delta):
	_fill_buffer()


func _ready():
	stream.mix_rate = sample_hz # Setting mix rate is only possible before play().
	playback = get_stream_playback()
	_fill_buffer() # Prefill, do before play() to avoid delay.
	play()
