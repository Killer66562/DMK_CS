class_name Wave
extends Node


signal end


func _ready():
	pass

func _on_EndTimer_timeout():
	emit_signal("end")
