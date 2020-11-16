extends Spatial

onready var player = get_node('../../playerroot/rigidplayer')
onready var playercam = player.get_node('player/ARVRCamera')
onready var body = get_node('torsobody')
onready var bodycontrol = get_node('KinematicBody')
onready var handl = get_node('armL/hand')
onready var handr = get_node('armR/hand')


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	bodycontrol.look_at(playercam.global_transform.origin, Vector3.UP)
	bodycontrol.global_transform.origin.x = body.global_transform.origin.x
	bodycontrol.global_transform.origin.z = body.global_transform.origin.z
	bodycontrol.rotation_degrees.x = 0
	bodycontrol.rotation_degrees.z = 0
	if handl.global_transform.origin.distance_to(playercam.global_transform.origin) < 5 || handr.global_transform.origin.distance_to(playercam.global_transform.origin) < 5:
		handl.add_central_force(((playercam.global_transform.origin - handl.global_transform.origin).normalized())*20)
		handr.add_central_force(((playercam.global_transform.origin - handr.global_transform.origin).normalized())*20)
		# print('addhandforce')
	# if bodycontrol.global_transform.origin.distance_to(body.global_transform.origin) > 1:
	# 	get_node('Generic6DOFJoint').set_node_b("")
		
