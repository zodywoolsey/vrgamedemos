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

func _ready():
	arServ = 'ovrMobile'
	# settingsFile = File.new()
	# if not settingsFile.file_exists('res://settings.txt'):
	# 	settingsFile.open('res://settings.txt', File.WRITE)
	# if settingsFile.open("res://settings.txt",File.READ) != 0:
	# 	print('Error, will crash')
	# var settingsData = ''
	# settingsData = settingsFile.get_line()
	# print(settingsData)
	if arServ == 'ovr':
		interface = ARVRServer.find_interface('OpenVR')
		arServ = 'ovr'
		Engine.iterations_per_second = 90
	elif arServ == 'oculus':
		interface = ARVRServer.find_interface('Oculus')
		arServ = 'oculus'
		Engine.iterations_per_second = 80
	if arServ == 'ovrMobile':
		interface = ARVRServer.find_interface("OVRMobile")
		ovr_init_config = load('res://addons/godot_ovrmobile/OvrInitConfig.gdns').new()
		ovr_performance = load('res://addons/godot_ovrmobile/OvrPerformance.gdns').new()
		ovr_init_config.set_render_target_size_multiplier(1)
		ovr_performance.set_clock_levels(1, 1)
		ovr_performance.set_extra_latency_mode(1)
		Engine.iterations_per_second = 72
			
	if interface.initialize():
		get_viewport().arvr = true
		OS.vsync_enabled = false
		if arServ == 'ovr':
			get_viewport().keep_3d_linear = true

	# initrand()
	# generateTris()

# func _process(_delta):
# 	if !perform_runtime_config:
# 		ovr_performance.set_clock_levels(1, 1)
# 		ovr_performance.set_extra_latency_mode(1)
# 		perform_runtime_config = true

# func initrand():
# 	nums = []
# 	var scale = 50
# 	for x in range(scale):
# 		for y in range(scale):
# 			seed( tan(x)-tan(y) )
# 			nums.append(randi())

# func generateTris():
# 	var tmpx = 0
# 	var tmpy = 0
# 	print( sqrt(len(nums)) )
# 	for i in range(len(nums)):
# 		seed(nums[i])
# 		var tmpars = vertsFromInt(randi())
# 		var tmparraymesh = ArrayMesh.new()
# 		tmparraymesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, tmpars)
# 		var testmesh = MeshInstance.new()
# 		testmesh.mesh = tmparraymesh
# 		add_child(testmesh)
# 		meshes.append(testmesh)
# 		if tmpx < sqrt(len(nums))/2:
# 			tmpx += .5
# 		else:
# 			tmpx = 0
# 			tmpy += .5
# 		if tmpy == sqrt(len(nums))/2:
# 			tmpy = 0
# 		var projectedpos = get_viewport().get_camera().project_position(Vector2((tmpx*20)+0,(tmpy*20)+0),40)
# 		# testmesh.translate(Vector3(tmpx,0,tmpy))
# 		testmesh.translate(projectedpos)

# func vertsFromInt(i):
# 	var tmp1 = Vector3()
# 	tmp1.x = (float(((i/10)%10))/10.0)*2
# 	tmp1.y = (float(((i/100)%10))/10.0)*2
# 	tmp1.z = (float(((i/1000)%10))/10.0)*2
# 	var tmp2 = Vector3()
# 	tmp2.x = (float(((i/100)%10))/10.0)*2
# 	tmp2.y = (float(((i/1000)%10))/10.0)*2
# 	tmp2.z = (float(((i/10000)%10))/10.0)*2
# 	var tmp3 = Vector3()
# 	tmp3.x = (float(((i/1000)%10))/10.0)*2
# 	tmp3.y = (float(((i/10000)%10))/10.0)*2
# 	tmp3.z = (float(((i/100000)%10))/10.0)*2

# 	var tmpVerts = PoolVector3Array()
# 	tmpVerts.push_back(tmp1)
# 	tmpVerts.push_back(tmp2)
# 	tmpVerts.push_back(tmp3)
	
# 	var tmpars = []
# 	tmpars.resize(ArrayMesh.ARRAY_MAX)
# 	tmpars[ArrayMesh.ARRAY_VERTEX] = tmpVerts

# 	return tmpars
	
