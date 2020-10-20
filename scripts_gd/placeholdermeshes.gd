extends Spatial


onready var capsule = get_node("capsule")
onready var cube = get_node("cube")
onready var cylinder = get_node("cylinder")
onready var plane = get_node("plane")
onready var prism = get_node("prism")
onready var quad = get_node("quad")
onready var sphere = get_node("sphere")
var mdt = MeshDataTool.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func getCapsuleArrayMesh():
	var tmp = ArrayMesh.new()
	tmp.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, capsule.mesh.surface_get_arrays())
	mdt.create_from_surface(tmp, 0)
	for i in range(mdt.get_vertex_count()):
		var vertex = mdt.get_vertex(i)

		mdt.set_vertex(i, vertex)
	mdt.commit_to_surface(tmp)
	return tmp

func getcubeArrayMesh():
	var tmp = ArrayMesh.new()
	tmp.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, cube.mesh.surface_get_arrays())
	mdt.create_from_surface(tmp, 0)
	for i in range(mdt.get_vertex_count()):
		var vertex = mdt.get_vertex(i)

		mdt.set_vertex(i, vertex)
	mdt.commit_to_surface(tmp)
	return tmp

func getCylinderArrayMesh():
	var tmp = ArrayMesh.new()
	tmp.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, cylinder.mesh.surface_get_arrays())
	mdt.create_from_surface(tmp, 0)
	for i in range(mdt.get_vertex_count()):
		var vertex = mdt.get_vertex(i)

		mdt.set_vertex(i, vertex)
	mdt.commit_to_surface(tmp)
	return tmp

func getPlaneArrayMesh():
	var tmp = ArrayMesh.new()
	tmp.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, plane.mesh.surface_get_arrays())
	mdt.create_from_surface(tmp, 0)
	for i in range(mdt.get_vertex_count()):
		var vertex = mdt.get_vertex(i)

		mdt.set_vertex(i, vertex)
	mdt.commit_to_surface(tmp)
	return tmp

func getPrismArrayMesh():
	var tmp = ArrayMesh.new()
	tmp.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, prism.mesh.surface_get_arrays())
	mdt.create_from_surface(tmp, 0)
	for i in range(mdt.get_vertex_count()):
		var vertex = mdt.get_vertex(i)

		mdt.set_vertex(i, vertex)
	mdt.commit_to_surface(tmp)
	return tmp

func getQuadArrayMesh():
	var tmp = ArrayMesh.new()
	tmp.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, quad.mesh.surface_get_arrays())
	mdt.create_from_surface(tmp, 0)
	for i in range(mdt.get_vertex_count()):
		var vertex = mdt.get_vertex(i)

		mdt.set_vertex(i, vertex)
	mdt.commit_to_surface(tmp)
	return tmp

func getSphereArrayMesh():
	var tmp = ArrayMesh.new()
	tmp.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, sphere.mesh.surface_get_arrays())
	mdt.create_from_surface(tmp, 0)
	for i in range(mdt.get_vertex_count()):
		var vertex = mdt.get_vertex(i)

		mdt.set_vertex(i, vertex)
	mdt.commit_to_surface(tmp)
	return tmp