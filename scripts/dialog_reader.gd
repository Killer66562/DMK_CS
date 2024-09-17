class_name DialogReader
extends Node


signal end


@export var DialogScene : PackedScene = null
@export_file("*.json") var dialog_file


@onready var dialogs : Array[Dialog] = []
@onready var current_dialog : Dialog = null
@onready var dialogs_size := 0
@onready var index := -1 : get = get_idx, set = set_idx


func get_idx():
	return index


func set_idx(value: int):
	if value <= 0:
		index = 0
	elif value >= dialogs_size - 1:
		index = dialogs_size - 1
	else:
		index = value


func _load_next_dialog():
	if current_dialog != null:
		get_tree().root.remove_child(current_dialog)
	if index >= dialogs_size - 1:
		end.emit()
	index = index + 1
	current_dialog = dialogs[index]
	get_tree().root.call_deferred("add_child", current_dialog)


func _load_prev_dialog():
	print(index)
	if current_dialog != null:
		get_tree().root.remove_child(current_dialog)
	index = index - 1
	current_dialog = dialogs[index]
	get_tree().root.call_deferred("add_child", current_dialog)


func _ready() -> void:
	var raw = FileAccess.open(dialog_file, FileAccess.READ).get_as_text()
	var json = JSON.new()
	var error = json.parse(raw)
	
	if error != OK:
		print("Data error")
		get_tree().quit()
		return
		
	var data = json.data
	
	if typeof(data) != TYPE_ARRAY:
		print("Data type error")
		get_tree().quit()
		return
	
	for dialog_data : Dictionary in data:
		var dialog_instance : Dialog = DialogScene.instantiate()
		
		dialog_instance.label_text = dialog_data.get("text", "")
		
		var image_path = dialog_data.get("image", "")
		
		dialog_instance.sprite_image = load(image_path)
		dialog_instance.connect("prev", Callable(self, "_load_prev_dialog"))
		dialog_instance.connect("next", Callable(self, "_load_next_dialog"))
		dialogs.append(dialog_instance)
	
	dialogs_size = dialogs.size()
	_load_next_dialog()
