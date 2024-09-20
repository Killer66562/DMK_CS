class_name CharacterSelectPanel
extends Node2D


@export var game : PackedScene = null
@export var character_infos : Array[PackedScene] = []


func _init_game(player: Player):
	var instance : Game = game.instantiate()
	instance.player = player
	get_tree().root.add_child(instance)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for character_info in character_infos:
		var instance = character_info.instantiate()
		instance.connect("select", Callable(self, "_init_game"))
		get_tree().root.add_child(instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
