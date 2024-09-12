class_name Bullet
extends Area2D


export var disappear_xy_min := Vector2(300, -100)
export var disappear_xy_max := Vector2(900, 900)
export var damage := 1
export var speed := 0.0
export var acceleration := 0.0
export var angular_velocity := 0.0
export var angular_acceleration := 0.0
export var rotate_velocity := 0.0
export var rotate_acceleration := 0.0
export var stopped := false
export var passthrough := false
export var freeze_secs := 0.0
export var dizzy_secs := 0.0


var velocity := Vector2(0, 0)


onready var entities_entered := []


func is_already_entered(entity) -> bool:
	return entity in entities_entered


func _ready() -> void:
	pass


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
	
	position = new_pos
	
	if position.x < disappear_xy_min.x or \
	position.y < disappear_xy_min.y or \
	position.x > disappear_xy_max.x or \
	position.y > disappear_xy_max.y:
		queue_free()


func _on_Bullet_area_entered(area: Area2D) -> void:
	if is_in_group("mob_bullet"):
		if area.is_in_group("player_area") and not passthrough:
			queue_free()
	elif is_in_group("player_bullet"):
		if (area.is_in_group("mob_area") or area.is_in_group("mob_spawner")) \
		and not passthrough:
			queue_free()
