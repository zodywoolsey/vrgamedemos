extends Spatial

# onready var ovr_init_config = preload("res://addons/godot_ovrmobile/OvrInitConfig.gdns").new()
# onready var ovr_performance = preload("res://addons/godot_ovrmobile/OvrPerformance.gdns").new()
var ovr_init_config
var ovr_performance

var perform_runtime_config = false
var arServ = ''

var settingsFile
var interface = null

var nums = []
var meshes = []

onready var buttons = get_node('menu')
onready var roomsbutton = get_node('menu/roomsbutton/button')
onready var obstaclecoursebutton = get_node('menu/obstaclecoursebutton/button')

func _ready():
	interface = ARVRServer.find_interface("OVRMobile")
	ovr_init_config = load('res://addons/godot_ovrmobile/OvrInitConfig.gdns').new()
	ovr_performance = load('res://addons/godot_ovrmobile/OvrPerformance.gdns').new()
	ovr_init_config.set_render_target_size_multiplier(1)
	ovr_performance.set_clock_levels(1, 1)
	ovr_performance.set_extra_latency_mode(1)
	Engine.iterations_per_second = 72
			
	if interface.initialize():
		get_viewport().size_override_stretch = true
		# print(get_viewport().get_size_override())
		get_viewport().arvr = true
		OS.vsync_enabled = false
		if arServ == 'ovr':
			get_viewport().keep_3d_linear = true

			
	# startup menu logic
	roomsbutton.connect("pressed",self,'loadrooms')
	obstaclecoursebutton.connect("pressed",self,'loadobstaclecourse')
	
	
func loadrooms():
	var tmplevel = load('res://levels/rooms.tscn')
	add_child(tmplevel.instance())
	buttons.global_transform.origin.y = -100
	buttons.visible = false
	
func loadobstaclecourse():
	var tmplevel = load('res://levels/obstacle course.tscn')
	add_child(tmplevel.instance())
	buttons.global_transform.origin.y = -100
	buttons.visible = false
