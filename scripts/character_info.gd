class_name CharacterInfo
extends Node


signal select(character)


@export var CharacterScene : PackedScene = null


@onready var character : Character = CharacterScene.instantiate() \
if CharacterScene else null
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	if character == null:
		get_tree().quit()
		return


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("select"):
		select.emit(character)
