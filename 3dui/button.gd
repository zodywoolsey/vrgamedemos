extends Spatial


onready var button = get_node('button')
onready var lightstick = load('res://lightstick.tscn')
var counter = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	button.connect("pressed",self,'btnpressed')


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func btnpressed():
	if counter < 5:
		var box = RigidBody.new()
		box.continuous_cd = true
		# box.mass = 5
		var mesh = MeshInstance.new()
		mesh.mesh = CubeMesh.new()
		mesh.mesh.size = Vector3(.1,.1,.1)
		box.add_child(mesh)
		var tmpcolsh = CollisionShape.new()
		tmpcolsh.shape = mesh.mesh.create_convex_shape()
		tmpcolsh.shape.margin = 0.0
		box.add_child(tmpcolsh)
		box.add_to_group('grabbable')
		get_tree().root.get_node('Node/startup').add_child(box)
		box.global_transform.origin = Vector3(global_transform.origin.x, global_transform.origin.y+.5, global_transform.origin.z-1)
		# var tmplight = lightstick.instance()
		# get_tree().root.get_node('Node/startup').add_child(tmplight)
		# tmplight.global_transform.origin = Vector3(global_transform.origin.x+1, global_transform.origin.y+.5, global_transform.origin.z)
		counter += 1
