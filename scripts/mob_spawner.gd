class_name MobSpawner
extends Area2D


@export var MobTypes : Array[PackedScene] = []


signal mob_spawn(mob)
signal mob_die(mob)
signal destroyed(spawner)


@export var health := 100
@export var spawn_radius := 0
@export var spawn_cooldown := 0
@export var max_mob_spawn_per_time := 0
@export var max_mob_can_spwan := 0
@export var score := 0


@onready var stopped := false
@onready var is_destroyed := false
@onready var mob_spawned := 0
@onready var mob_types_size = MobTypes.size()


#Check all pre-requests in this function
func _check() -> void:
	if mob_types_size <= 0:
		push_error("At least one type of Mob is required")
		get_tree().quit()
	for MobType in MobTypes:
		var mob = MobType.instantiate()
		if not is_instance_of(mob, Mob):
			mob.queue_free()
			push_error("Only Mob type is allowed")
			get_tree().quit()
			return
		mob.queue_free()


func _on_Mob_died(mob):
	emit_signal("mob_die", mob)


func _spawn_mob() -> void:
	for i in range(randi() % max_mob_spawn_per_time + 1):
		var index = randi() % mob_types_size
		var mob = MobTypes[index].instantiate()
		mob.connect("die", Callable(self, "_on_Mob_died"))
		var spawn_pos = position + Vector2(
			randf_range(-spawn_radius, spawn_radius), 
			randf_range(-spawn_radius, spawn_radius)
		)
		mob.position = spawn_pos
		get_tree().root.call_deferred("add_child", mob)
		mob_spawned += 1
		emit_signal("mob_spawn", mob)


func _ready() -> void:
	randomize()
	_check()
	$ProgressBar.max_value = health
	$ProgressBar.value = health
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
		if health <= 0 and not is_destroyed:
			is_destroyed = true
			emit_signal("destroyed", self)
			queue_free()
		$ProgressBar.value = health
