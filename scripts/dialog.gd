class_name Dialog
extends Node2D


signal prev
signal next


@export_multiline var label_text = ""
@export var sprite_image : CompressedTexture2D = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RichTextLabel.text = label_text
	$Sprite2D.texture = sprite_image


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_prev_button_down() -> void:
	prev.emit()


func _on_button_next_button_down() -> void:
	next.emit()
