extends ARVRController

var handGrab
var handArea
var handBody
var handRay
var uiRay
var grabShader = preload('res://handGrabMaterial.tres')
var handcollider
var otherhand

# onready var handaudio = get_node('handaudio')

var grabDown = false
var triggerDown = false

var rayOn = false

var rayCollidedNode
var rayCollidedNodeMesh = null
var rayCollidedNodeOrigin
var handOrigin
var towardVector
var forceScaleFactor
var distance
var forceStrength = 50

var gravtmp = null
var damptmp = null
var rayCollidedtmp = null
var tmpMat = null
var pullInterval = 0
var couldsleep = false

var body
var isCollided
var collides
var grabbed = false
var isGrabbable
var grabbedObject = null
var grabbedObjectOrigin
var collidedArea = null

var useObject = false

#this is for sound generation lol
var lastorigin
var neworigin
var audioval

# climbing
var climbjoint
export var climbmod = 75
onready var rigidplayer = get_node('../../')
export var climbing = false
var climbstartpos = Vector3()
var climbbodystartpos = Vector3()

# Called when the node enters the scene tree for the first time.
func _ready():
	handGrab = get_node('HandGrab')
	handArea = get_node('HandArea')
	handBody = get_node('HandBody')
	handRay = handBody.get_node('HandRay')
	uiRay = handBody.get_node('UiRay')
	handcollider = handBody.get_node('handcollider')
	if name == "rightHand":
		climbjoint = get_node('../../../climbjoint_r')
		otherhand = get_node('../leftHand')
	if name == "leftHand":
		climbjoint = get_node('../../../climbjoint_l')
		otherhand = get_node('../rightHand')
	print(otherhand)


func _physics_process(delta):
	# handaudio.pulse_hz = 4+(5*((handBody.linear_velocity.length()+handBody.angular_velocity.length())/2))
	if handBody.transform.origin != Vector3(0,0,0):
		handBody.transform.origin = Vector3(0,0,0)
	if grabDown:
		if climbing:
			climb()
			# rigidplayer.global_transform.origin += (climbstartpos-global_transform.origin)
			rigidplayer.move_and_slide( (climbstartpos-global_transform.origin)*climbmod )
			climbstartpos = global_transform.origin
		grab()
		if triggerDown && !grabbed:
			pull()
	if (grabbedObject && grabbed) && !climbing:
		var isStaticCollided = false
		collides = handArea.get_overlapping_bodies()
		for col in collides:
			if col.get_class() == "StaticBody":
				isStaticCollided = true
				break
		grabbedObjectOrigin = grabbedObject.global_transform.origin
		if isStaticCollided && ( sqrt( pow(grabbedObjectOrigin.x-global_transform.origin.x,2)+pow(grabbedObjectOrigin.y-global_transform.origin.y,2)+pow(grabbedObjectOrigin.z-global_transform.origin.z,2) ) > .1 ):
			handGrab.set_node_b('')
			grabbedObject = null
	if grabbedObject && grabbedObject.is_in_group("useable"):
		if useObject:
			grabbedObject.active = true
		if !useObject:
			grabbedObject.active = false
	if grabbedObject && !grabbed:
		handGrab.set_node_b("")
		grabbedObject.can_sleep = true
		if( grabbedObject.is_in_group("useable")):
			grabbedObject.active = false
		grabbedObject = null
	if triggerDown:
		applyGrabShader()
#	if !grabbed:
#		handArea.get_overlapping_bodies()
			
func _on_Hand_button_pressed(button):
	if button == 2:
		grabDown = true
		if rayCollidedNodeMesh:
			rayCollidedNodeMesh.material_override = null
			rayCollidedNodeMesh = null
			tmpMat = null
		grab()
		climb()
	if button == 15 && !grabbed && !uiRay.enabled:
		triggerDown = true
		rayOn = true
		handRay.enabled = true
		handRay.show()
	if button == 15 && grabbed:
		useObject = true
	if button == 7 and name == "rightHand":
		rigidplayer.jumpbuttonpressed = true
	# if button == 15 && uiRay.enabled:
	# 	uiRay.press()
	# if button == 7 && uiRay.enabled == false:
	# 	uiRay.enabled = true
	# 	uiRay.show()
	# elif button == 7 && uiRay.enabled == true:
	# 	uiRay.enabled = false
	# 	uiRay.hide()

func _on_Hand_button_release(button):
	if button == 2:
		grabDown = false
		climbing = false
		climbstartpos = Vector3()
		if grabbed:
			grabbed = false
		if rayCollidedNode:
			rayCollidedNode.set_gravity_scale(gravtmp)
			rayCollidedNode.set_linear_damp(damptmp)
			rayCollidedtmp = null
			rayCollidedNode = null
			gravtmp = null
			damptmp = null
	if button == 15:
		triggerDown = false
		useObject = false
		rayOn = false
		handRay.enabled = false
		handRay.hide()
		if rayCollidedNode:
			rayCollidedNode.set_gravity_scale(gravtmp)
			rayCollidedNode.set_linear_damp(damptmp)
			rayCollidedtmp = null
			rayCollidedNode = null
			gravtmp = null
			damptmp = null
		if rayCollidedNodeMesh:
			rayCollidedNodeMesh.material_override = null
			rayCollidedNodeMesh = null
			tmpMat = null
		# if uiRay.enabled:
		# 	uiRay.release()


func _on_HandArea_body_entered(body):
	isCollided = true

func _on_HandArea_body_exited(body):
	isCollided = false

func _on_HandArea_area_shape_entered(_areaId, area, _stupidParam, _stupidParam2):
	collidedArea = area

func _on_HandArea_area_shape_exited(_areaId, _area, _stupidParam, _stupidParam2):
	collidedArea = null

func grab():
	if isCollided && !grabbed && !climbing:
		collides = handArea.get_overlapping_bodies()
		for col in collides:
			isGrabbable = false
			isGrabbable = col.is_in_group('grabbable')
			if col.get_class() == "RigidBody" && isGrabbable:
				grabbedObject = col
				# grabbedObject.global_transform = handBody.global_transform
				# if grabbedObject.handle:
				# 	grabbedObject.global_transform.position = handBody.global_transform.position+grabbedObject.handle
				# else:
				handGrab.set_node_b(col.get_path())
				col.can_sleep = false
				grabbed = true
				if handRay.enabled == true:
					handRay.enabled = false
					handRay.hide()
					# handcollider.set_disabled(true)
					if rayCollidedtmp:
						rayCollidedtmp.set_gravity_scale(gravtmp)
						rayCollidedtmp.set_linear_damp(damptmp)
						rayCollidedtmp = null
						rayCollidedNode = null
						damptmp = null
						gravtmp = null
					rayOn = false
				break
	if collidedArea != null && collidedArea.is_in_group('spawnBox') && !grabbed:
		collidedArea.activate()
		collidedArea = null

func climb():
	if isCollided && !grabbed && !climbing:
		collides = handArea.get_overlapping_bodies()
		for col in collides:
			if col.get_class() == "StaticBody":
				if climbing == false:
					if otherhand.climbing:
						otherhand.climbing = false
					climbing = true
					climbstartpos = global_transform.origin
					climbbodystartpos = rigidplayer.global_transform.origin
					break
		
func pull():
	applyGrabShader()
	if handRay.is_colliding() && !rayCollidedNode && handRay.get_collider().get_class() == "RigidBody" && handRay.get_collider().is_in_group('grabbable'):
		rayCollidedNode = get_node(handRay.get_collider().get_path())
		rayCollidedNodeMesh = rayCollidedNode.find_node('MeshInstance',true,true)
		pullInterval = 0
	if grabDown && rayCollidedNode:
		rayCollidedNodeOrigin = rayCollidedNode.get_global_transform().origin
		handOrigin = get_global_transform().origin
		# distance = sqrt( pow(handOrigin.x-rayCollidedNodeOrigin.x, 2)+pow(handOrigin.z-rayCollidedNodeOrigin.z, 2)+pow(handOrigin.y-rayCollidedNodeOrigin.y, 2) )
		distance = sqrt( pow(handOrigin.x-rayCollidedNodeOrigin.x, 2)+pow(handOrigin.z-rayCollidedNodeOrigin.z, 2) )
		# print(distance)
		if distance < (pullInterval/50)+.4:
			rayCollidedNode.global_transform = global_transform
		else:
			pullInterval += 1
		if !rayCollidedtmp || !gravtmp || !damptmp:
			rayCollidedtmp = rayCollidedNode
			gravtmp = rayCollidedtmp.get_gravity_scale()
			damptmp = rayCollidedtmp.get_linear_damp()
		if rayCollidedNode != rayCollidedtmp:
			rayCollidedtmp.set_gravity_scale(gravtmp)
			rayCollidedtmp = rayCollidedNode
			gravtmp = rayCollidedtmp.get_gravity_scale()
			damptmp = rayCollidedtmp.get_linear_damp()
		forceStrength = rayCollidedNode.get_mass()*50
		rayCollidedNode.set_gravity_scale(0)
		towardVector = handOrigin-rayCollidedNodeOrigin
		if abs(towardVector[0]) > abs(towardVector[1]) && abs(towardVector[0]) > abs(towardVector[2]):
			forceScaleFactor = abs(forceStrength/towardVector[0])
		elif abs(towardVector[1]) > abs(towardVector[0]) && abs(towardVector[1]) > abs(towardVector[2]):
			forceScaleFactor = abs(forceStrength/towardVector[1])
		elif abs(towardVector[2]) > abs(towardVector[1]) && abs(towardVector[2]) > abs(towardVector[0]):
			forceScaleFactor = abs(forceStrength/towardVector[2])
		towardVector = towardVector*forceScaleFactor
		rayCollidedNode.add_force( towardVector, Vector3(0,0,0))




func applyGrabShader():
	if rayCollidedNodeMesh && handRay.is_colliding():
		if rayCollidedNodeMesh != get_node(handRay.get_collider().get_path()).find_node('MeshInstance',true,true):
			rayCollidedNodeMesh.material_override = null
			rayCollidedNodeMesh = null
			tmpMat = null
	elif rayCollidedNodeMesh && handRay.is_colliding() == false:
		rayCollidedNodeMesh.material_override = null
		rayCollidedNodeMesh = null
		tmpMat = null
	if handRay.is_colliding() && !rayCollidedNode && handRay.get_collider().get_class() == "RigidBody" && handRay.get_collider().is_in_group('grabbable'):
		rayCollidedNodeMesh = get_node(handRay.get_collider().get_path()).find_node('MeshInstance',true,true)
		if rayCollidedNodeMesh:
			rayCollidedNodeMesh.material_override = grabShader
			rayCollidedNodeMesh.material_override.next_pass = rayCollidedNodeMesh.get_surface_material(0)


