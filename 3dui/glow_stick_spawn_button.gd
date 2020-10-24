extends Spatial


onready var button = get_node('button')
onready var lightstick = preload('res://weapons/lightstick.tscn')
onready var startup = get_tree().root.get_node('Node/startup')
var counter = 0

func _ready():
	button.connect("pressed",self,'btnpressed')

func btnpressed():
	if counter < 5:
		counter += 1
		var tmp = lightstick.instance()
		tmp.global_transform.origin = global_transform.origin+Vector3(0,0,-1)
		startup.add_child(tmp)
		