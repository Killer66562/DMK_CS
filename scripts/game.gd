class_name Game
extends Node2D


signal end


export (Array, PackedScene) var Stages


#Timing
onready var days := 0
onready var hours := 0
onready var minutes := 0
onready var seconds := 0


#Game
onready var score := 0 setget set_score, get_score
onready var current_stage: Stage = null
onready var stage_index = 0


func _update_stage_text():
	var text = "%s\n%s" % \
	[current_stage.stage_name, current_stage.stage_introduction]
	$StageLabel.text = text


func _update_timer_text():
	var hours_str = str(hours) if hours >= 10 else "0" + str(hours)
	var minutes_str = str(minutes) if minutes >= 10 else "0" + str(minutes)
	var seconds_str = str(seconds) if seconds >= 10 else "0" + str(seconds)
	$TimerLabel.text = \
	"%d days, %s:%s:%s" % [days, hours_str, minutes_str, seconds_str]


func _update_score_text():
	var score_str = "score: %d" % [score]
	$ScoreLabel.text = score_str


func _update_player_power_text():
	var player_power_text = "player power: %d" % [$MalePlayer.power]
	$PlayerPowerLabel.text = player_power_text


func set_score(value: int):
	if value > 0:
		score = value
	else:
		score = 0


func get_score() -> int:
	return score


func add_score(value: int):
	score = score + value
	_update_score_text()


func remove_score(value: int):
	score = score - value
	_update_score_text()


func load_next_stage():
	if stage_index < Stages.size():
		current_stage = Stages[stage_index].instance()
		current_stage.connect("clear", self, "load_next_stage")
		current_stage.connect("spawner_destroyed", self, "add_score")
		get_tree().root.call_deferred("add_child", current_stage)
		_update_stage_text()
		$StageLabel.show()
		$StageTextTimer.start()
		stage_index += 1
	else:
		emit_signal("end")


func _ready():
	_update_timer_text()
	_update_score_text()
	_update_player_power_text()
	load_next_stage()


func _on_Timer_timeout():
	var secs = seconds + 1
	if secs >= 60:
		seconds = 0
		var mins = minutes + 1
		if mins >= 60:
			minutes = 0
			var hrs = hours + 1
			if hrs >= 24:
				hours = 0
				days += 1
			else:
				hours = hrs
		else:
			minutes = mins
	else:
		seconds = secs
	_update_timer_text()


func _on_MalePlayer_position_update():
	get_tree().call_group("mob", "update_player_position", $MalePlayer.position)


func _on_StageTextTimer_timeout():
	$StageLabel.hide()


func _on_MalePlayer_power_update(power):
	_update_player_power_text()
