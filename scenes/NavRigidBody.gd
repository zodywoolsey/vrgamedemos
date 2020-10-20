extends MeshInstance

onready var rigidbody = get_node("RigidBody")
onready var collisionshape = get_node("RigidBody/CollisionShape")

# Called when the node enters the scene tree for the first time.
func _ready():
	collisionshape.shape = mesh.create_convex_shape()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
