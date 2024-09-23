class_name MalePlayer
extends Player


signal add_score(score)
signal remove_score(score)
signal power_update(power)


@onready var original_power := 0


func _init() -> void:
	health = 10
	position = Vector2(600, 700)


func _ready() -> void:
	is_invincible = true
	$ShootTimer.wait_time = 0.1
	$ShootTimer.start()
	$InvincibleTimer.start()
	$AnimatedSprite2D.play()
	$Health.value = health


func _shoot_bullet() -> void:
	for i in range(-power, power + 1):
		var bullet: Bullet = BulletType.instantiate()
		bullet.add_to_group("player_bullet")
		bullet.position = position
		bullet.speed = bullet_speed
		bullet.velocity = Vector2(sin(PI / 12 * i), -1).normalized()
		bullet.angular_velocity = PI / 24 * i
		bullet.rotate_velocity = PI / 2
		bullet.rotate_acceleration = PI / 6
		bullet.passthrough = true
		bullet.add_to_group("player_bullet")
		get_tree().root.add_child(bullet)


func _process(delta: float) -> void:
	var velocity_next = Vector2(0, 0)
	var current_speed = speed
	
	if Input.is_action_pressed("move_right"):
		velocity_next.x += 1
	if Input.is_action_pressed("move_left"):
		velocity_next.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity_next.y += 1
	if Input.is_action_pressed("move_up"):
		velocity_next.y -= 1
	if Input.is_action_pressed("slow_down"):
		current_speed *= 0.5
	
	velocity_next = velocity_next.normalized()
	
	position += velocity_next * current_speed * delta
	emit_signal("position_update")
	
	if Input.is_action_pressed("shoot_bullet") and can_shoot:
		can_shoot = false
		$ShootTimer.start()
		_shoot_bullet()
	
	if Input.is_action_pressed("use_skill") and can_use_skill:
		emit_signal("use_skill")


func _on_InvincibleTimer_timeout() -> void:
	is_invincible = false
	$AnimatedSprite2D.animation = "default"


func _on_ShootTimer_timeout():
	can_shoot = true


func _be_invincible():
	is_invincible = true
	$AnimatedSprite2D.animation = "invincible"
	$InvincibleTimer.start()


func _on_CollisionArea_area_entered(area):
	if area.is_in_group("mob_bullet") and not is_invincible:
		_be_invincible()
		health -= area.damage
		$Health.value = health
		$AudioStreamPlayer.play()
	if area.is_in_group("mob_area") and not is_invincible:
		_be_invincible()
		health -= 1
		$Health.value = health
		remove_score.emit(2000)
		$AudioStreamPlayer.play()
	if health <= 0:
		emit_signal("die")
		queue_free()
		return
	if area.is_in_group("item"):
		if area.is_in_group("power"):
			var new_power = power + area.power
			if new_power >= max_power:
				new_power = max_power
			power = new_power
			if $SkillTimer.time_left > 0:
				original_power += area.power
				if original_power >= max_power:
					original_power = max_power
			emit_signal("power_update", power)
		if area.is_in_group("health"):
			health = health + area.health
			$Health.value = health
		if area.is_in_group("score"):
			emit_signal("add_score", area.score)


func _on_SkillTimer_timeout():
	power = original_power
	$SkillCooldownTimer.start()


func _on_SkillCooldownTimer_timeout():
	can_use_skill = true


func _on_MalePlayer_use_skill():
	can_use_skill = false
	original_power = power
	power += 2
	$SkillTimer.start()


func _on_mlg_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("mob_bullet") and not area.sliced:
		area.sliced = true
		add_score.emit(100)
