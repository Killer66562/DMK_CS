extends Mob


func _shoot_bullet():
	var bullet = BulletTypes[randi() % bullet_types_size].instance()
	bullet.velocity = (player_position - position).normalized()
	bullet.speed = 200
	bullet.rotate_velocity = PI
	bullet.position = position
	bullet.damage = 1
	bullet.add_to_group("mob_bullet")
	get_tree().root.add_child(bullet)


func _ready():
	._ready()
	$ProgressBar.max_value = health
	$ProgressBar.value = health


func _process(delta):
	position += velocity * speed * delta


func _on_ShootTimer_timeout():
	_shoot_bullet()


func _on_MoveTimer_timeout():
	var next_position = \
	Vector2(
		player_position.x + rand_range(-80, 80), 
		position.y + rand_range(-40, 40)
	)
	var next_velocity = (next_position - position).normalized()
	var next_speed = \
	position.distance_to(next_position) / $MoveStopTimer.wait_time
	
	speed = 0
	velocity = next_velocity
	speed = next_speed
	
	$MoveStopTimer.start()


func _on_CollisionArea_area_entered(area):
	if area.is_in_group("player_bullet"):
		health -= area.damage
		$ProgressBar.value = health
		if health <= 0:
			queue_free()


func _on_MoveStopTimer_timeout():
	speed = 0
