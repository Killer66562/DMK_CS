class_name Character
extends Node2D


export var speed := 0.0
export var health := 0
export var shoot_cooldown := 0.25


onready var can_shoot := true
onready var stopped := false


var shoot_times := 0


export var velocity := Vector2(0, 0)


func _shoot_bullet() -> void:
	can_shoot = false
	shoot_times += 1


func _ready() -> void:
	$ShootTimer.wait_time = shoot_cooldown
	$ShootTimer.start()


func _on_ShootTimer_timeout() -> void:
	can_shoot = true
