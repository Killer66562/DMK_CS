class_name Character
extends Node2D


signal die


export var speed := 0.0 setget set_speed, get_speed
export var health := 0 setget set_health, get_health
export var shoot_cooldown := 0.25


func set_health(value: int):
	if value < 0:
		health = 0
	else:
		health = value


func get_health() -> int:
	return health


func set_speed(value: float):
	if value < 0:
		speed = 0
	else:
		speed = value


func get_speed() -> float:
	return speed


onready var can_shoot := true
onready var stopped := false


var shoot_times := 0


export var velocity := Vector2(0, 0)


func _shoot_bullet() -> void:
	pass


func _ready() -> void:
	pass
