class_name MobSpawner
extends Node2D

#Only classes that extended Mob are allowed
#Overwrite it in _init() of the children classes
export (Array, PackedScene) var MobTypes = []


signal mob_spawn(mob)


export var spawn_radius := 0.0
export var spawn_cooldown := 0.3


onready var stopped := false
onready var mob_spawned := 0
onready var mob_types_size = MobTypes.size()


#Check all pre-requests in this function
func _check() -> void:
	if mob_types_size <= 0:
		push_error("At least one type of Mob is required")
		get_tree().quit()
	for MobType in MobTypes:
		var instance = MobType.instance()
		if not instance as Mob:
			instance.queue_free()
			push_error("Only Mob type is allowed")
			get_tree().quit()
			return
		instance.queue_free()
	print("Test passed!")


func _spawn_mob() -> void:
	var index = randi() % mob_types_size
	var MobType = MobTypes[index]
	var mob = MobType.instance()
	var spawn_pos = position + Vector2(
		rand_range(-spawn_radius, spawn_radius), 
		rand_range(-spawn_radius, spawn_radius)
	)
	spawn_pos.x = clamp(spawn_pos.x, 0, 400)
	spawn_pos.y = clamp(spawn_pos.y, 0, 800)
	mob.position = spawn_pos
	mob.set_as_toplevel(true)
	mob_spawned += 1
	emit_signal("mob_spawn", mob)


func _ready() -> void:
	randomize()
	_check()
	$Timer.wait_time = spawn_cooldown
	$Timer.start()


func _process(delta: float) -> void:
	pass


func _on_Timer_timeout() -> void:
	if not stopped:
		_spawn_mob()
		if mob_spawned >= 5:
			stopped = true
	else:
		$Timer.stop()
