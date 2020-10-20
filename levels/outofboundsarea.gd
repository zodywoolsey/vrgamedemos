extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Area_body_entered(body):
	if body.is_in_group('mainbody') || body.is_in_group('grabbable'):
		body.global_transform.origin.y = 1
		if body.get_class() == "RigidBody":
			body.linear_velocity = body.linear_velocity*0
			body.angular_velocity = body.angular_velocity*0