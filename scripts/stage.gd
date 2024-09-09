class_name Stage
extends Node


signal start
signal clear


export (Array, PackedScene) var Waves
export var stage_name := ""


onready var index := 0
onready var waves_size = Waves.size()


func _ready():
	emit_signal("start")
	$FirstWaveLoadTimer.start()


onready var current_wave : Wave = null


func _load_next_wave() -> void:
	if index < waves_size:
		current_wave = Waves[index].instance()
		current_wave.connect("end", self, "_load_next_wave")
		get_tree().root.add_child(current_wave)
		index += 1
	else:
		emit_signal("clear")


func _on_FirstWaveLoadTimer_timeout():
	_load_next_wave()


func _on_MalePlayer_position_update():
	get_tree().call_group("mob", "update_player_position", $MalePlayer.position)
