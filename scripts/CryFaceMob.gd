extends Mob


func _shoot_bullet():
	var bullet = BulletTypes[randi() % bullet_types_size].instance()
	bullet.velocity = Vector2(0, 1).normalized()
	bullet.speed = 200
	bullet.rotate_velocity = PI
	bullet.position = position
	get_tree().root.add_child(bullet)


func _ready():
	._ready()


func _on_ShootTimer_timeout():
	_shoot_bullet()
