extends CharacterBody3D
#MOVE THE CAMERA AROUND WITH THE MOUSE
#move the player with the keyboard
#constrain the mouse

@export var gravity:float = 10.0
@export var max_jumps:int = 0
var jumps = 1

@export var muzzle_flash_time: float = 0.1


func _ready() -> void:
	#capture the mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.screen_relative.x * 0.5
		#rotate up and down
		%Camera3D.rotation_degrees.x -= event.screen_relative.y * 0.2
		%Camera3D.rotation_degrees.x = clamp(%Camera3D.rotation_degrees.x, -80.0, 80.0)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("fullscreen"):
		var fs = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
		if fs:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_get_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			
func _physics_process(delta: float) -> void:
	const speed = 15.5 #meters per second
	#walk
	var input_direction_2D = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var input_direction_3D = Vector3(input_direction_2D.x, 0, input_direction_2D.y)
	
	var direction = transform.basis * input_direction_3D
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	#jumping
	#gravity
	#y directional
	velocity.y -= gravity * delta
	#check for the jump key
	if Input.is_action_just_pressed("move_jump") and jumps <= max_jumps: #is_on_floor():
		velocity.y = 10.0
		
		jumps += 1
		
	elif Input.is_action_just_pressed("move_jump") and velocity.y > 0.0:
		velocity.y = 0.0
	
	if is_on_floor():
		jumps = 0
	
	move_and_slide()
	
	if Input.is_action_pressed("move_shoot") and $BulletTimer.is_stopped():
		shoot_bullet()
	
func shoot_bullet():
	#get a reference projectile scene
	const BULLET_3D = preload("res://scenes/projectile.tscn")
	#instantiate
	var new_bullet = BULLET_3D.instantiate()
	#add instance as a child
	%ProjectileSpawnPoint.add_child(new_bullet)
	#connect to spawn location
	new_bullet.transform = %ProjectileSpawnPoint.global_transform
	#play sounds, turn on lights, particles?

	$BulletTimer.start()
	%MuzzleLight.visible = true
	await get_tree() .create_timer(0.1).timeout
	%MuzzleLight.visible = false
