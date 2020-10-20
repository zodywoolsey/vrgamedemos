extends Spatial


var mdt = MeshDataTool.new()
var timesincelastframe = 0
var time = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	var one = get_node('one')
	var mesh = one.mesh
	var armesh = ArrayMesh.new()
	armesh.add_surface_from_arrays( Mesh.PRIMITIVE_TRIANGLES ,mesh.surface_get_arrays(0))
	mdt.create_from_surface(armesh,0)

	armesh.surface_remove(0)
	mdt.commit_to_surface(armesh)
	get_node('RigidBody/two').mesh = armesh
	get_node('RigidBody/CollisionShape').shape = armesh.create_trimesh_shape()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timesincelastframe > 0.0:
		var two = get_node('RigidBody/two')
		var mesh = two.mesh
		var one = get_node('one')
		var armesh = ArrayMesh.new()
		armesh.add_surface_from_arrays( Mesh.PRIMITIVE_TRIANGLES ,one.mesh.surface_get_arrays(0))
		mdt.create_from_surface(armesh,0)
		var tmpnum = randi()%mdt.get_vertex_count()
		for i in range(mdt.get_vertex_count()):
			var vertex = mdt.get_vertex(i)
			vertex.x = sin(vertex.x+time)
			vertex.y = sin(vertex.y+time)
			vertex.z = sin(vertex.z+time)
			mdt.set_vertex(i, vertex)
			# print(vertex)

		mesh.surface_remove(0)
		mdt.commit_to_surface(mesh)
		get_node('RigidBody/CollisionShape').shape = mesh.create_trimesh_shape()
		timesincelastframe = 0
	timesincelastframe += delta
	time += delta


	
	# for i in range(mdt.get_vertex_count()):
	# 	var vertex = mdt.get_vertex(i)
	# 	vertex.x = vertex.x + (randi()%100)/50
	# 	vertex.y = vertex.y + (randi()%100)/50
	# 	vertex.z = vertex.z + (randi()%100)/50
	# 	mdt.set_vertex(i, vertex)

	
	# var vertex = mdt.get_vertex(tmpnum)
	# vertex.x = vertex.x + (randi()%100)/50
	# vertex.y = vertex.y + (randi()%100)/50
	# vertex.z = vertex.z + (randi()%100)/50
	# vertex.x = sin(vertex.x+delta)
	# vertex.y = sin(vertex.y+delta)
	# vertex.z = sin(vertex.z+delta)
	# mdt.set_vertex(tmpnum, vertex)
