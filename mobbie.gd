extends RigidBody3D

@onready var bat_model: Node3D = $"bat_model (Inherited)"
@export var health:= 5.0
@onready var player = get_node("/root/World/Player")

func take_damage(damage):
	health -= damage
	bat_model.hurt()
	if health <= 0:
		set_physics_process(false)
		gravity_scale = 1.0
		var direction = -global_position.direction_to(player.global_position)
		var random_upward_force = Vector3.UP * randf() * 5
		
		apply_central_impulse(direction.rotated(Vector3.UP, randf_range(-0.2, 0.2)) * 10.0 * random_upward_force)
	print(health)
