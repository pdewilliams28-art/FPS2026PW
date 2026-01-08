extends CharacterBody3D
#MOVE THE CAMERA AROUND WITH THE MOUSE
#move the player with the keyboard
#constrain the mouse



func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.screen_relative.x * 0.5
		#rotate up and down
		%Camera3D.rotation_degrees.x -= event.screen_relative.y * 0.2
		%Camera3D.rotation_degrees.x = clamp(%Camera3D.rotation_degrees.x, -80.0, 80.0)



func _physics_process(delta: float) -> void:
		const speed = 15.5 #meters per second
	#walk
		var input_direction_2D = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
		var input_direction_3D = Vector3(input_direction_2D.x, 0, input_direction_2D.y)
		
		var direction = transform.basis * input_direction_3D
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		
		move_and_slide()
