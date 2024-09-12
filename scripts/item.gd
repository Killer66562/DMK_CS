class_name Item
extends Area2D


@export var speed := 0.0
@export var velocity := Vector2(0, 0)


func _on_Item_area_entered(area):
	if area.is_in_group("player_area"):
		queue_free()


func _process(delta):
	position += velocity * speed * delta
