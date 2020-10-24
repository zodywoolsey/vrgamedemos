extends KinematicBody


onready var right = get_node('player/rightHand')
onready var left = get_node('player/leftHand')
onready var cam = get_node('player/ARVRCamera')
onready var playerbody = get_node('playerbody')
onready var groundcheck = get_node('groundcheck')
onready var playerorigin = get_node('player')
onready var climbjointl = get_node('../climbjoint_l')
onready var climbjointr = get_node('../climbjoint_r')

onready var rx
onready var ry
onready var lx
onready var ly

var speed = 3
var deadzone = 0.42
var jump = 10

var h_acceleration = 6
var h_velocity = Vector3()
var direction = Vector3()
var movement = Vector3()
var gravityvec = Vector3()
var gravity = 5
var fullcontact = false
var rotateflag = true

var jumpbuttonpressed = false
var walking = false

var rloc
var lloc
var hloc

onready var playeraudio = get_node("AudioStreamPlayer")
var stepplaying = false

# Called when the node enters the scene tree for the first time.
func _ready():
	print('player started')
	print( get_viewport().size )
	
	
	
func _process(delta):
	# cam.rotation = Vector3(0,90,0)
	rloc = right.get_node("HandArea/CollisionShape/MeshInstance").global_transform
	lloc =  left.get_node( "HandArea/CollisionShape/MeshInstance").global_transform
	hloc = get_node("player/ARVRCamera").global_transform

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	walking = false
	rx = right.get_joystick_axis(0)
	ry = right.get_joystick_axis(1)
	lx =  left.get_joystick_axis(0)
	ly =  left.get_joystick_axis(1)

	var leftstickvector = Vector2(lx,ly)
	var rightstickvector= Vector2(rx,ry)

	direction = Vector3()

	if groundcheck.is_colliding():
		fullcontact = true
	else:
		fullcontact = false

	if not is_on_floor():
		gravityvec += Vector3.DOWN * gravity * delta
	elif is_on_floor() and fullcontact:
		gravityvec = -get_floor_normal() * gravity
	else:
		gravityvec = -get_floor_normal()

	
	if abs(leftstickvector.x) < deadzone:
		leftstickvector.x = 0
	if abs(leftstickvector.y) < deadzone:
		leftstickvector.y = 0
		
	if abs(rightstickvector.x) < deadzone:
		rightstickvector.x = 0
	if abs(rightstickvector.y) < deadzone:
		rightstickvector.y = 0
	if abs(rightstickvector.x) < deadzone && abs(rightstickvector.y) < deadzone:
		rotateflag = true
	
	leftstickvector = leftstickvector.normalized() * ((leftstickvector.length() - deadzone) / (1 - deadzone))
	if leftstickvector.y > 0:
		direction -= cam.global_transform.basis.z
		walking = true
	elif leftstickvector.y < 0:
		direction += cam.global_transform.basis.z
		walking = true
	if leftstickvector.x > 0:
		direction += cam.global_transform.basis.x
		walking = true
	elif leftstickvector.x < 0:
		direction -= cam.global_transform.basis.x
		walking = true
		
	if rotateflag == true:
		if rightstickvector.y > 0:
			rotateflag = false
		elif rightstickvector.y < 0:
			rotateflag = false
		if rightstickvector.x > 0:
			var tmporigin = cam.global_transform.origin
			rotate(Vector3.UP, deg2rad(-45))
			var tmpneworigin = cam.global_transform.origin
			global_transform.origin += (tmporigin-tmpneworigin)
			# print(tmporigin)
			# print(tmpneworigin)
			rotateflag = false
		elif rightstickvector.x < 0:
			var tmporigin = cam.global_transform.origin
			rotate(Vector3.UP, deg2rad(45))
			var tmpneworigin = cam.global_transform.origin
			global_transform.origin += (tmporigin-tmpneworigin)
			rotateflag = false
	if jumpbuttonpressed && is_on_floor():
		jumpbuttonpressed = false
		h_velocity.y += jump

	direction = direction.normalized()
	direction.y = 0
	h_velocity = h_velocity.linear_interpolate(direction * speed, h_acceleration * delta)
	movement.z = h_velocity.z + gravityvec.z
	movement.x = h_velocity.x + gravityvec.x
	movement.y = h_velocity.y + gravityvec.y

	if !right.climbing && !left.climbing:
		move_and_slide(movement, Vector3.UP)
	playerbody.global_transform.origin.x = cam.global_transform.origin.x
	playerbody.global_transform.origin.z = cam.global_transform.origin.z
	
	playerbody.shape.height = cam.transform.origin.y/2
	
	if walking && !right.climbing && !left.climbing && !playeraudio.playing:
		playeraudio.play()
		stepplaying = true
	elif !walking && !playeraudio.playing:
		playeraudio.stop()
		stepplaying = false
	
	# climbjointl.global_transform.origin = left.global_transform.origin
	# climbjointr.global_transform.origin = right.global_transform.origin

