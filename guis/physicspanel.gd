extends Control


var selected


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func select(col):
	selected = col

func _on_gravityone_pressed():
	selected.get_parent().gravity_scale = -0.1

func _on_gravitytwo_pressed():
	selected.get_parent().gravity_scale = 0.0

func _on_gravitythree_pressed():
	selected.get_parent().gravity_scale = 0.5

func _on_gravityfour_pressed():
	selected.get_parent().gravity_scale = 1.0