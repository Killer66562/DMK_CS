class_name CharacterSelectPanel
extends Node


@export var game : PackedScene = null
@export var CharacterInfos : Array[PackedScene] = []


@onready var character_infos : Array[CharacterInfo] = []
@onready var character_infos_size = CharacterInfos.size()
@onready var current_character_info : CharacterInfo = null
@onready var index := 0


func _init_game(player: Player):
	var instance : Game = game.instantiate()
	instance.player = player
	get_tree().root.remove_child(current_character_info)
	get_tree().root.add_child(instance)
	queue_free()


func _prev_character_info():
	index = character_infos_size - 1 if index <= 0 else index - 1
	get_tree().root.remove_child(current_character_info)
	current_character_info = character_infos[index]
	get_tree().root.add_child(current_character_info)


func _next_character_info():
	index = 0 if index >= character_infos_size - 1 else index + 1
	get_tree().root.remove_child(current_character_info)
	current_character_info = character_infos[index]
	get_tree().root.add_child(current_character_info)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for character_info in CharacterInfos:
		var instance = character_info.instantiate()
		instance.connect("select", Callable(self, "_init_game"))
		character_infos.append(instance)
	current_character_info = character_infos[0]
	get_tree().root.call_deferred("add_child", current_character_info)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_right"):
		_next_character_info()
	elif Input.is_action_just_pressed("move_left"):
		_prev_character_info()
	else:
		pass
