extends StaticBody

onready var mesh = get_node('MeshInstance')
var time = 0
var healthregentimer = 0

var stats = {}

func _ready():
	stats.health = 100


func _process(delta):
	time += delta
	healthregentimer += delta
	if healthregentimer > 1 && stats.health < 100:
		stats.health += .5
	if stats.health < 1:
		stats.health = 1
	if stats.health < 50:
		mesh.mesh.material.albedo_color = Color('#f00')
	elif stats.health >= 50:
		mesh.mesh.material.albedo_color = Color('#adf')
		
