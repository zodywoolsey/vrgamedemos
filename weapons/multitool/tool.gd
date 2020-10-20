extends RigidBody

var bulletloc
var bulletorigin

var boloc
var bloc

var bullet
var t = 0

var active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	bulletloc = get_node("bulletloc")
	bulletorigin = get_node("bulletorigin")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	t += delta
	if active:
		activate()



func activate():
	if t > .2:
		bullet = load('res://weapons/multitool/bullet.tscn').instance()
		bullet.global_transform = bulletloc.global_transform
		get_tree().root.add_child(bullet)
		bloc = Vector3(bulletloc.global_transform.origin.x,bulletloc.global_transform.origin.y,bulletloc.global_transform.origin.z)
		boloc = Vector3(bulletorigin.global_transform.origin.x,bulletorigin.global_transform.origin.y,bulletorigin.global_transform.origin.z)
		
		bullet.add_central_force(-800*(boloc-bloc).normalized())
		t = 0
	
