extends ARVRController

var handGrab
var handArea
var handBody
var handRay
var grabShader

var otherHandGrab

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

var body
var isCollided
var collides
var grabbed = false
var isGrabbable
var grabbedObject = null
var grabbedObjectOrigin
var collidedArea = null

# var velStartTransformOrigin
# var velEndTransformOrigin
# var vel


# Called when the node enters the scene tree for the first time.
func _ready():
	handGrab = findNode('leftHandGrab')
	otherHandGrab = findNode('rightHandGrab')
	handArea = findNode('leftHandArea')
	handBody = findNode('leftHandBody')
	handRay = findNode('leftHandRay')
	grabShader = load('res://handGrabMaterial.tres')


func _physics_process(delta):
	if grabDown:
		grab()
	if triggerDown && grabDown && !grabbed:
		grab()
		pull()
	if (grabbedObject && grabbed):
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
	if otherHandGrab.get_node_b() == handGrab.get_node_b():
		handGrab.set_node_b('')
		grabbedObject = null
	if grabbedObject && !grabbed:
		handGrab.set_node_b("")
		grabbedObject = null
	if triggerDown:
		applyGrabShader()
			
func _on_leftHand_button_pressed(button):
	if button == 2:
		grabDown = true
		if rayCollidedNodeMesh:
			rayCollidedNodeMesh.material_override = null
			rayCollidedNodeMesh = null
			tmpMat = null
	if button == 15 && !grabbed:
		triggerDown = true
		rayOn = true
		handRay.enabled = true
		handRay.show()

func _on_leftHand_button_release(button):
	if button == 2:
		grabDown = false
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


func _on_leftHandArea_body_entered(body):
	isCollided = true

func _on_leftHandArea_body_exited(body):
	isCollided = false

func _on_leftHandArea_area_shape_entered(areaId, area, stupidParam, stupidParam2):
	collidedArea = area

func _on_leftHandArea_area_shape_exited(areaId, area, stupidParam, stupidParam2):
	collidedArea = null

func grab():
	if isCollided && !grabbed:
		collides = handArea.get_overlapping_bodies()
		for col in collides:
			isGrabbable = false
			isGrabbable = checkNodeGroups(col, 'grabbable')
			if col.get_class() == "RigidBody" && isGrabbable:
				grabbedObject = col
				grabbedObject.global_transform = handBody.global_transform
				handGrab.set_node_b(col.get_path())
				grabbed = true
				if handRay.enabled == true:
					handRay.enabled = false
					handRay.hide()
					if rayCollidedtmp:
						rayCollidedtmp.set_gravity_scale(gravtmp)
						rayCollidedtmp.set_linear_damp(damptmp)
						rayCollidedtmp = null
						rayCollidedNode = null
						damptmp = null
						gravtmp = null
					rayOn = false
				break
	if collidedArea != null && checkNodeGroups(collidedArea, 'spawnBox') && !grabbed:
		collidedArea.activate()
		collidedArea = null

func pull():
	applyGrabShader()
	if handRay.is_colliding() && !rayCollidedNode && handRay.get_collider().get_class() == "RigidBody" && checkNodeGroups(handRay.get_collider(), 'grabbable'):
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


func findNode(nodeName):
	return get_node('/root').find_node(nodeName, true, false)

func checkNodeGroups(node, groupName):
	for group in node.get_groups():
		if group == groupName:
			return true
	return false
func checkNodeNameGroups(nodeName, groupName):
	for group in findNode(nodeName).get_groups():
		if group == groupName:
			return true
	return false


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
	if handRay.is_colliding() && !rayCollidedNode && handRay.get_collider().get_class() == "RigidBody" && checkNodeGroups(handRay.get_collider(), 'grabbable'):
		rayCollidedNodeMesh = get_node(handRay.get_collider().get_path()).find_node('MeshInstance',true,true)
		if rayCollidedNodeMesh:
			rayCollidedNodeMesh.material_override = grabShader
			rayCollidedNodeMesh.material_override.next_pass = rayCollidedNodeMesh.get_surface_material(0)


