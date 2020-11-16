extends Spatial


onready var rigidmapmeshes = get_tree().get_nodes_in_group("RigidMapMesh")


# Called when the node enters the scene tree for the first time.
func _ready():
	var tmpbody = StaticBody.new()
	for i in rigidmapmeshes:
		var tmpcollisionshape = CollisionShape.new()
		var tmpshape = i.mesh.create_convex_shape()
		tmpshape.margin = 0.001
		tmpcollisionshape.shape = tmpshape
		tmpbody.add_child(tmpcollisionshape)
		tmpcollisionshape.global_transform = i.global_transform

		# tmpbody.mode = RigidBody.MODE_STATIC
		# tmpbody.contact_monitor = false
		# tmpbody.can_sleep = true
		# tmpbody.continuous_cd = true
		# tmpbody.mass = 65535
		# tmpbody.weight = 65535
		tmpbody.set_collision_layer_bit(1,true)
		tmpbody.set_collision_mask_bit(1,true)

		# tmpbody.add_child(AudioStreamPlayer3D.new())
		i.mesh.subdivide_depth = i.mesh.size.z*8
		i.mesh.subdivide_height = i.mesh.size.y*8
		i.mesh.subdivide_width = i.mesh.size.x*8
	add_child(tmpbody)
		# tmpbody.connect("body_entered",self,"collisionsound")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# func collisionsound(col):
# 	print("collided with: " + col.name)
