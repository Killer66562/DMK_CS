class_name Mob
extends Character


#I need a method to get the player from its parents
var player_position := Vector2(0, 0)

#Only use the types that extends Bullet
#Overwrite it in _init() of the children classes
var BulletTypes = [Bullet]


onready var bullet_types_size = BulletTypes.size()


func _ready() -> void:
	_check()
	randomize()

#Check all pre-requests in this function
func _check() -> void:
	if bullet_types_size <= 0:
		push_error("At least one type of Bullet is required")
		get_tree().quit()
	for BulletType in BulletTypes:
		var instance = BulletType.new()
		if not instance as Bullet:
			instance.queue_free()
			push_error("Only Bullet type is allowed")
			get_tree().quit()
		instance.queue_free()
	print("Test passed!")


func _shoot_bullet() -> void:
	var index = randi() % bullet_types_size
	var BulletType = BulletTypes[index]
	var bullet : Bullet = BulletType.new()
	bullet.position = position
	bullet.velocity = Vector2(0, 1)
	get_tree().root.add_child(bullet)
	._shoot_bullet()


func _process(_delta: float) -> void:
	if can_shoot:
		_shoot_bullet()


func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_bullet_area"):
		health -= area.damage
		if health <= 0:
			queue_free()
