class_name Mob
extends Character


#I need a method to get the player from its parents
var player_position := Vector2(0, 0)
export var move_cooldown := 5.0
export var move_to_next_pos_in_sec := 1.0

#Only use the types that extends Bullet
#Overwrite it in _init() of the children classes
export (Array, PackedScene) var BulletTypes


onready var bullet_types_size = BulletTypes.size()
onready var can_move = false


func update_player_position(pos: Vector2):
	player_position = pos


func _ready() -> void:
	_check()
	randomize()
	$ShootTimer.wait_time = shoot_cooldown
	$MoveTimer.wait_time = move_cooldown
	$MoveStopTimer.wait_time = move_to_next_pos_in_sec
	$ShootTimer.start()
	$MoveTimer.start()

#Check all pre-requests in this function
func _check() -> void:
	if bullet_types_size <= 0:
		push_error("At least one type of Bullet is required")
		get_tree().quit()
	for BulletType in BulletTypes:
		var instance = BulletType.instance()
		if not instance as Bullet:
			instance.queue_free()
			push_error("Only Bullet type is allowed")
			get_tree().quit()
		instance.queue_free()
