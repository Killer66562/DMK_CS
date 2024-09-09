class_name Player
extends Character


signal position_update
signal use_skill


export (PackedScene) var BulletType
export var power := 0
export var invinsible_sec := 5.0
export var bullet_speed := 0
export var bullet_velocity := Vector2(0, 0)


onready var is_invincible = false
onready var can_use_skill = true


func _check() -> void:
	var instance = BulletType.instance()
	if not instance as Bullet:
		instance.queue_free()
		push_error("Only Bullet type is allowed")
		get_tree().quit()
		instance.queue_free()
	instance.queue_free()


func _shoot_bullet():
	pass


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass
