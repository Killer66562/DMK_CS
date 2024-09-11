class_name Wave
extends Node


signal end
signal spawner_destroyed(score)


export var is_boss_wave := false


export (Array, PackedScene) var Spawners
export (Array, Vector2) var spawner_positions


onready var spawners_size = Spawners.size()
onready var spawner_positions_size = spawner_positions.size()
onready var spawners := []
onready var spawned_mobs := []


func _check():
	if spawners_size != spawner_positions_size:
		push_error("The size of drop items needs to equal the size of weights")
		get_tree().quit()
	for spawner in Spawners:
		var instance = spawner.instance()
		if not instance as MobSpawner:
			push_error("The size of drop items needs to equal the size of weights")
			get_tree().quit()


func _ready():
	_check()
	for i in range(spawners_size):
		var spawner : MobSpawner = Spawners[i].instance()
		spawners.append(spawner)
		spawner.position = spawner_positions[i]
		spawner.connect("destroyed", self, "_on_MobSpawner_destroyed")
		spawner.connect("mob_spawn", self, "_on_Mob_spawned")
		get_tree().root.call_deferred("add_child", spawner)


func _process(delta: float) -> void:
	_run_early_end()


func _early_end():
	spawners.clear()
	spawned_mobs.clear()
	$EndTimer.paused = true
	var lasting_time = $EndTimer.time_left - $EarlyEndTimer.wait_time
	if lasting_time < $EarlyEndTimer.wait_time:
		$EndTimer.paused = false
	else:
		$EarlyEndTimer.start()


func _run_early_end():
	if spawners.size() <= 0 and spawned_mobs.size() <= 0:
		return
	for spawner in spawners:
		if spawner != null:
			return
	for mob in spawned_mobs:
		if mob != null:
			return
	_early_end()


func _on_EndTimer_timeout():
	spawners.clear()
	spawned_mobs.clear()
	emit_signal("end")


func _on_Mob_spawned(mob):
	spawned_mobs.append(mob)


func _on_MobSpawner_destroyed(spawner):
	emit_signal("spawner_destroyed", spawner.score)


func _on_EarlyEndTimer_timeout() -> void:
	spawners.clear()
	spawned_mobs.clear()
	emit_signal("end")
