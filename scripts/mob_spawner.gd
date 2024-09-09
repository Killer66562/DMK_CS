class_name MobSpawner
extends Area2D


export (Array, PackedScene) var MobTypes = []


signal mob_spawn(mob)


export var health := 100
export var spawn_radius := 0
export var spawn_cooldown := 0
export var max_mob_spawn_per_time := 0
export var max_mob_can_spwan := 0


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


func _spawn_mob() -> void:
	for i in range(randi() % max_mob_spawn_per_time + 1):
		var index = randi() % mob_types_size
		var mob = MobTypes[index].instance()
		var spawn_pos = position + Vector2(
			rand_range(-spawn_radius, spawn_radius), 
			rand_range(-spawn_radius, spawn_radius)
		)
		mob.position = spawn_pos
		get_tree().root.add_child(mob)
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
		if mob_spawned >= max_mob_can_spwan:
			stopped = true
			$Timer.stop()


func _on_MobSpawner_area_entered(area):
	if area.is_in_group("player_bullet"):
		health -= area.damage
