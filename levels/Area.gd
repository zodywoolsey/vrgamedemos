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
	if body.is_in_group('grabbable'):
		print('grav scale is: ' + str(body.gravity_scale))
		if body.gravity_scale == 1:
			body.gravity_scale = .4
			body.add_central_force(Vector3((randi()%5)+1,1000,(randi()%5)+1))
			print('body made light')
		elif body.gravity_scale > 0.3 && body.gravity_scale < 0.5:
			body.gravity_scale = -.2
			print('body made antigrav')
		elif body.gravity_scale < -.1 && body.gravity_scale > -0.3:
			body.gravity_scale = 1
			body.add_central_force(Vector3((randi()%5)+1,2000,(randi()%5)+1))
			print('body grav normal')
			
			
func _on_Area_body_exited(body):
	print('body exited')