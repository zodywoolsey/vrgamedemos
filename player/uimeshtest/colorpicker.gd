extends Control


onready var color = $ColorPicker
var selected

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func select(col):
	selected = col

func _on_ColorPicker_color_changed(selectedColor):
	var tmpmesh = selected.get_node('MeshInstance')
	var tmpmat = tmpmesh.get_surface_material(0)
	tmpmat.albedo_color = selectedColor
	tmpmesh.set_surface_material(0,tmpmat)
