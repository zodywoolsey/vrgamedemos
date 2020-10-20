extends RigidBody


var startpos


# Called when the node enters the scene tree for the first time.
func _ready():
	startpos = transform.origin


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	transform.origin.y = startpos.y
	# if transform.origin.y < startpos.y:
	# 	transform.origin.y = startpos.y