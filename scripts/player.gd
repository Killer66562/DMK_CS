class_name Player
extends Character


signal position_update


export (PackedScene) var BulletType
export var power := 0
export var invinsible_sec := 5.0
export var bullet_speed := 0
export var bullet_velocity := Vector2(0, 0)


onready var is_invincible = false


func _check() -> void:
	var instance = BulletType.instance()
	if not instance as Bullet:
		instance.queue_free()
		push_error("Only Bullet type is allowed")
		get_tree().quit()
		instance.queue_free()
	instance.queue_free()


func _shoot_bullet():
	can_shoot = false


func _ready() -> void:
	_check()
	$InvincibleTimer.wait_time = invinsible_sec
	$AnimatedSprite.animation = "default"


func _process(delta: float) -> void:
	emit_signal("position_update")
	if can_shoot:
		_shoot_bullet()


func _on_CollisionArea_area_entered(area: Area2D) -> void:
	if not is_invincible:
		if area.is_in_group("mob_bullet"):
			is_invincible = true
			health -= 1
			$AnimatedSprite.animation = "invincible"
			$InvincibleTimer.start()
			get_tree().call_group("player_bullet", "queue_free")


func _on_InvincibleTimer_timeout() -> void:
	is_invincible = false
	$AnimatedSprite.animation = "default"
