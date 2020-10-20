extends Spatial


var door
onready var button = get_node('button')
var tween = Tween.new()
var shadertween = Tween.new()
onready var mesh = get_node('button/MeshInstance')

# Called when the node enters the scene tree for the first time.
func _ready():
	door = get_tree().get_nodes_in_group('door1')[0]
	button.connect("pressed",self,'btnpressed')
	add_child(tween)
	add_child(shadertween)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func btnpressed():
	# print('pressed')
	if door.transform.origin.y > 0:
		print('door open')
		tween.interpolate_property(door, "transform:origin:y",2,-2,0.6,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		tween.start()
		var tmpmat = mesh.get_surface_material(0)
		tmpmat.albedo_color.r8 = 100
		tmpmat.albedo_color.g8 = 255
		tmpmat.albedo_color.b8 = 100
		mesh.set_surface_material(0, tmpmat)
		# door.global_transform.origin.y -= 5
	else:
		print('door close')
		tween.interpolate_property(door, "transform:origin:y",-2,2,0.6,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		tween.start()
		var tmpmat = mesh.get_surface_material(0)
		tmpmat.albedo_color.r8 = 255
		tmpmat.albedo_color.g8 = 100
		tmpmat.albedo_color.b8 = 100
		mesh.set_surface_material(0, tmpmat)
		# door.global_transform.origin.y += 5
		
