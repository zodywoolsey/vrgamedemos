extends Spatial

onready var player = get_node('../playerroot/rigidplayer')
onready var playercam = player.get_node('player/ARVRCamera')
onready var body = get_node('torsobody')
onready var bodycontrol = get_node('KinematicBody')
onready var handl = get_node('armL/hand')
onready var handr = get_node('armR/hand')


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	bodycontrol.look_at(playercam.global_transform.origin, Vector3.UP)
	bodycontrol.rotation_degrees.x = 0
	bodycontrol.rotation_degrees.z = 0
	if bodycontrol.global_transform.origin.distance_to(playercam.global_transform.origin) < 5:
		handl.add_central_force(((playercam.global_transform.origin - handl.global_transform.origin).normalized())*100)
		handr.add_central_force(((playercam.global_transform.origin - handr.global_transform.origin).normalized())*100)
		# print('addhandforce')
