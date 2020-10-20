extends KinematicBody


var path = []
var pathindex = 0
var move_speed = 2
onready var nav = get_tree().root.find_node("Navigation",true,false)

var health = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group('units')
	move_to(Vector3(0,0,0))

func _physics_process(delta):
	if health < 1:
		queue_free()
	if pathindex < path.size():
		var move_vec = (path[pathindex] - global_transform.origin)
		if move_vec.length() < .1:
			pathindex += 1
		else:
			move_and_slide((move_vec.normalized() * move_speed), Vector3.UP)
			# print(move_vec.normalized()*move_speed)
	else:
		move_to(Vector3((randi()%20)-10,(randi()%4),(randi()%20)-10))
	

func move_to(targetpos):
	path = nav.get_simple_path(global_transform.origin, targetpos)
	pathindex = 0
