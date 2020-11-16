extends RigidBody

var active = false
onready var ray = get_node('RayCast')

func _ready():
	pass


func _physics_process(delta):
	print(active)
	if active:
		if ray.is_colliding():
			print(ray.get_collision_point())
