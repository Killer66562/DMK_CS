extends Mob


func _shoot_bullet():
	var moded = randi() % bullet_types_size
	var bullet = BulletTypes[moded].instance()
	bullet.position = position
	if moded == 0:
		bullet.velocity = (player_position - position).normalized()
		bullet.speed = 200
		bullet.rotate_velocity = PI
		bullet.damage = 1
	elif moded == 1:
		bullet.velocity = Vector2(0, 1).normalized()
		bullet.speed = 100
		bullet.acceleration = 400
		bullet.damage = 2
		bullet.rotate(PI)
	elif moded == 2:
		bullet.velocity = Vector2(0, 1).normalized()
		bullet.rotate_velocity = PI / 2
		bullet.speed = 50
		bullet.damage = 1
	bullet.add_to_group("mob_bullet")
	get_tree().root.add_child(bullet)


func _drop_item():
	if drop_item_types_size <= 0 or weights_size <= 0:
		return null
	if randf() >= item_drop_percentage:
		return null
	var total = 0
	for num in weights:
		total += num
	var moded = randi() % total
	var index = 0
	var current_sum = 0
	for num in weights:
		current_sum += num
		if moded < current_sum:
			var item = DropItemTypes[index].instance()
			item.velocity = Vector2(0, 1).normalized()
			item.speed = 100
			item.position = position
			get_tree().root.call_deferred("add_child", item)
			return
		index += 1


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
		if health <= 0 and not is_dead:
			is_dead = true
			emit_signal("die", self)
			_drop_item()
			queue_free()


func _on_MoveStopTimer_timeout():
	speed = 0
