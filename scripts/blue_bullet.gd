extends Bullet


@onready var player_position := Vector2(0, 0)


func update_player_position(pos: Vector2):
	player_position = pos


func _process(delta: float) -> void:
	if stopped:
		return

	speed += acceleration * delta
	angular_velocity += angular_acceleration * delta
	rotate_velocity += rotate_acceleration * delta
	velocity = velocity.rotated(angular_velocity * delta).normalized()
	rotate(rotate_velocity * delta)
	
	var new_pos = position
		
	new_pos += velocity * speed * delta
	
	if new_pos.distance_to(player_position) < 50:
		var new_velocity = Vector2(
			new_pos.x - player_position.x, 
			new_pos.y - player_position.y
		).normalized()
		velocity = new_velocity
	
	new_pos = position + velocity * speed * delta
	position = new_pos
	
	if position.x < disappear_xy_min.x or \
	position.y < disappear_xy_min.y or \
	position.x > disappear_xy_max.x or \
	position.y > disappear_xy_max.y:
		queue_free()
