extends RigidBody


# onready var joint = get_node('../SliderJoint')
var outpos
var inpos

var pressedflag

signal pressed()


# Called when the node enters the scene tree for the first time.
func _ready():
	outpos = transform.origin
	inpos = outpos+Vector3(0,0,-.1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# add_collision_exception_with(get_parent())
	
	# add_central_force(Vector3(0,0,1))
	
	# transform.origin.y = 0
	# transform.origin.x = 0
	if transform.origin.z > outpos.z:
		# transform.origin.z = outpos.z*.9
		# linear_velocity = Vector3(0,0,0)
		pass
	elif transform.origin.z < inpos.z*0.9:
		# transform.origin.z = inpos.z*.8
		# linear_velocity = Vector3(0,0,0)
		pressed()
	if transform.origin.z > ((outpos.z+inpos.z)/2):
		pressedflag = false

		
func pressed():
	if pressedflag == false:
		pressedflag = true
		emit_signal("pressed")
		# print('pressed')
		
