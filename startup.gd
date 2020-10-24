extends Spatial

var perform_runtime_config = false
var arServ = ''

var settingsFile
var interface = null

var nums = []
var meshes = []

onready var buttons = get_node('menu')
onready var roomsbutton = get_node('menu/roomsbutton/button')
onready var obstaclecoursebutton = get_node('menu/obstaclecoursebutton/button')

var ovr_display_refresh_rate
var ovr_guardian_system
var ovr_performance
var ovr_tracking_transform
var ovr_utilities
var ovr_vr_api_proxy
var ovr_input
var ovr_init_config
var _performed_runtime_config
var ovrVrApiTypes = load("res://addons/godot_ovrmobile/OvrVrApiTypes.gd").new();

func _ready():
	_initialize_ovr_mobile_arvr_interface()
	# else:
	# 	interface = ARVRServer.find_interface("OVRMobile")
	
	# startup menu logic
	roomsbutton.connect("pressed",self,'loadrooms')
	obstaclecoursebutton.connect("pressed",self,'loadobstaclecourse')
	

func _process(delta_t):
	_check_and_perform_runtime_config()
	
func loadrooms():
	var tmplevel = load('res://levels/rooms.tscn')
	get_node('snow').queue_free()
	var tmp = tmplevel.instance()
	tmp.global_transform.origin = get_node('playerroot/rigidplayer/player/ARVRCamera').global_transform.origin
	tmp.global_transform.origin.y = 0
	add_child(tmp)
	buttons.global_transform.origin.y = -100
	buttons.visible = false
	
# func loadobstaclecourse():
# 	var tmplevel = load('res://levels/obstacle course.tscn')
# 	add_child(tmplevel.instance())
# 	buttons.global_transform.origin.y = -100
# 	buttons.visible = false




# this code check for the OVRMobile inteface; and if successful also initializes the
# .gdns APIs used to communicate with the VR device
func _initialize_ovr_mobile_arvr_interface():
	# Find the OVRMobile interface and initialise it if available
	var arvr_interface = ARVRServer.find_interface("OVRMobile")
	if !arvr_interface:
		print("Couldn't find OVRMobile interface")
	else:
		# the init config needs to be done before arvr_interface.initialize()
		ovr_init_config = load("res://addons/godot_ovrmobile/OvrInitConfig.gdns");
		if (ovr_init_config):
			ovr_init_config = ovr_init_config.new()
			ovr_init_config.set_render_target_size_multiplier(0.9) # setting to 1 here is the default

		# Configure the interface init parameters.
		if arvr_interface.initialize():
			get_viewport().arvr = true
			Engine.iterations_per_second = 72 # Quest

			# load the .gdns classes.
			ovr_display_refresh_rate = load("res://addons/godot_ovrmobile/OvrDisplayRefreshRate.gdns");
			ovr_guardian_system = load("res://addons/godot_ovrmobile/OvrGuardianSystem.gdns");
			ovr_performance = load("res://addons/godot_ovrmobile/OvrPerformance.gdns");
			ovr_tracking_transform = load("res://addons/godot_ovrmobile/OvrTrackingTransform.gdns");
			ovr_utilities = load("res://addons/godot_ovrmobile/OvrUtilities.gdns");
			ovr_vr_api_proxy = load("res://addons/godot_ovrmobile/OvrVrApiProxy.gdns");
			ovr_input = load("res://addons/godot_ovrmobile/OvrInput.gdns")

			# and now instance the .gdns classes for use if load was successfull
			if (ovr_display_refresh_rate): ovr_display_refresh_rate = ovr_display_refresh_rate.new()
			if (ovr_guardian_system): ovr_guardian_system = ovr_guardian_system.new()
			if (ovr_performance): ovr_performance = ovr_performance.new()
			if (ovr_tracking_transform): ovr_tracking_transform = ovr_tracking_transform.new()
			if (ovr_utilities): ovr_utilities = ovr_utilities.new()
			if (ovr_vr_api_proxy): ovr_vr_api_proxy = ovr_vr_api_proxy.new()
			if (ovr_input): ovr_input = ovr_input.new()

			# Connect to the plugin signals
			_connect_to_signals()

			print("Loaded OVRMobile")
			return true
		else:
			print("Failed to enable OVRMobile")
			return false

#thing
func _check_and_perform_runtime_config():
	if _performed_runtime_config: return

	if (ovr_performance):
		# these are some examples of using the ovr .gdns APIs
		ovr_performance.set_clock_levels(3, 3)
		ovr_performance.set_extra_latency_mode(ovrVrApiTypes.OvrExtraLatencyMode.VRAPI_EXTRA_LATENCY_MODE_ON)
		ovr_performance.set_foveation_level(4);  # 0 == off; 4 == highest

	_performed_runtime_config = true
	

func _connect_to_signals():
	if Engine.has_singleton("OVRMobile"):
		var singleton = Engine.get_singleton("OVRMobile")
		print("Connecting to OVRMobile signals")
		singleton.connect("HeadsetMounted", self, "_on_headset_mounted")
		singleton.connect("HeadsetUnmounted", self, "_on_headset_unmounted")
		singleton.connect("InputFocusGained", self, "_on_input_focus_gained")
		singleton.connect("InputFocusLost", self, "_on_input_focus_lost")
		singleton.connect("EnterVrMode", self, "_on_enter_vr_mode")
		singleton.connect("LeaveVrMode", self, "_on_leave_vr_mode")
	else:
		print("Unable to load OVRMobile singleton...")
		

func _on_headset_mounted():
	print("VR headset mounted")

func _on_headset_unmounted():
	print("VR headset unmounted")

func _on_input_focus_gained():
	print("Input focus gained")

func _on_input_focus_lost():
	print("Input focus lost")

func _on_enter_vr_mode():
	print("Entered Oculus VR mode")

func _on_leave_vr_mode():
	print("Left Oculus VR mode")
		
