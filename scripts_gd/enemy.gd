extends RigidBody

var collidedObjects
var iscollided
var handle = Vector3(0,.5,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass


func _on_RigidBody_body_entered(body):
	# print(body)
	pass
