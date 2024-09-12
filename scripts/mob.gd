class_name Mob
extends Character


#I need a method to get the player from its parents
@export var move_cooldown := 5.0
@export var move_to_next_pos_in_sec := 1.0
@export var item_drop_percentage := 0.0

#Only use the types that extends Bullet
#Overwrite it in _init() of the children classes
@export var BulletTypes : Array[PackedScene] = []
@export var DropItemTypes : Array[PackedScene] = []
@export var weights : Array[int] = []


@onready var bullet_types_size = BulletTypes.size()
@onready var drop_item_types_size = DropItemTypes.size()
@onready var weights_size = weights.size()
@onready var can_move = false
@onready var is_dead := false
@onready var player_position := Vector2(position.x, position.y)


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
	if drop_item_types_size != weights_size:
		push_error("The size of drop items needs to equal the size of weights")
		get_tree().quit()
	for BulletType in BulletTypes:
		var instance = BulletType.instantiate()
		if not is_instance_of(instance, Bullet):
			instance.queue_free()
			push_error("Only Bullet type is allowed")
			get_tree().quit()
		instance.queue_free()
	for DropItemType in DropItemTypes:
		var instance = DropItemType.instantiate()
		if not is_instance_of(instance, Item):
			instance.queue_free()
			push_error("Only Item type is allowed")
			get_tree().quit()
