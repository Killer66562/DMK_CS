class_name MalePlayer
extends Player


func _init() -> void:
	health = 10
	position = Vector2(600, 700)


func _ready() -> void:
	$AnimatedSprite.animation = "default"


func _shoot_bullet() -> void:
	._shoot_bullet()
	for i in range(-power, power + 1):
		var bullet: Bullet = BulletType.instance()
		bullet.add_to_group("player_bullet")
		bullet.position = position
		bullet.speed = bullet_speed
		bullet.velocity = Vector2(sin(PI / 12 * i), -1).normalized()
		bullet.angular_velocity = PI / 24 * i
		bullet.rotate_velocity = PI / 2
		bullet.rotate_acceleration = PI / 6
		get_tree().root.add_child(bullet)


func _process(delta: float) -> void:
	var velocity_next = Vector2(0, 0)
	
	if Input.is_action_pressed("move_right"):
		velocity_next.x += 1
	if Input.is_action_pressed("move_left"):
		velocity_next.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity_next.y += 1
	if Input.is_action_pressed("move_up"):
		velocity_next.y -= 1
	
	velocity_next = velocity_next.normalized()
	
	position += velocity_next * speed * delta
	emit_signal("position_update")
	
	if can_shoot:
		_shoot_bullet()


func _on_InvincibleTimer_timeout() -> void:
	._on_InvincibleTimer_timeout()
