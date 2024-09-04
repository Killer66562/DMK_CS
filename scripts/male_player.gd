class_name MalePlayer
extends Player


func _init() -> void:
	health = 10
	position = Vector2(600, 700)


func _ready() -> void:
	$AnimatedSprite.animation = "default"


func _shoot_bullet() -> void:
	._shoot_bullet()
	for i in range(-1, 2):
		var bullet: Bullet = BulletType.instance()
		bullet.add_to_group("player_bullet")
		bullet.position = position
		bullet.speed = 200
		bullet.velocity = Vector2(sin(PI / 6 * i), -1).normalized()
		bullet.angular_velocity = PI / 24 * i
		bullet.rotate_velocity = PI / 2
		bullet.rotate_acceleration = PI / 6
		get_tree().root.add_child(bullet)


func _process(delta: float) -> void:
	if can_shoot:
		_shoot_bullet()


func _on_InvincibleTimer_timeout() -> void:
	._on_InvincibleTimer_timeout()
