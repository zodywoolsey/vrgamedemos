extends RayCast


var col
var colpoint
var click = false
var selected
var gui = load('res://uimeshtest/gui_panel_3d.tscn')

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	colpoint = get_collision_point()
	col = get_collider()
	if col:
		if col.is_in_group("uinode"):
			col.get_parent().get_parent().get_parent().handle_ray_in(colpoint, 0)

func press():
	if col:
		if col.is_in_group("uinode"):
			colpoint = get_collision_point()
			col = get_collider()
			col.get_parent().get_parent().get_parent().handle_ray_in(colpoint, 1)
			click = true
		if col.is_in_group('edit'):
			selected = col
			var tmp = gui.instance()
			get_tree().root.add_child(tmp)
			tmp.transform.origin = col.get_parent().transform.origin + Vector3( 0.0, tmp.node_quad.mesh.size.y, 0.0 )
			tmp.select(col)

func release():
	if col:
		if col.is_in_group("uinode"):
			colpoint = get_collision_point()
			col = get_collider()
			col.get_parent().get_parent().get_parent().handle_ray_in(colpoint, 2)
			click = false

func select():
	if col:
		if col.is_in_group("edit"):
			selected = col
			var tmp = gui.instance()
			get_tree().root.add_child(tmp)
