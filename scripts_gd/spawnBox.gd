extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var item
var active = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func activate():
	if active > 0:
		item = load('res://scenes/whip-big.tscn').instance()
		item.global_transform = global_transform
		get_tree().root.add_child(item)
		active -= 1
	

func _on_spawnBox_body_entered():
	pass

func _on_spawnBox_body_exited():
	pass