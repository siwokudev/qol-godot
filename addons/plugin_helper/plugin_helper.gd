@tool
extends EditorPlugin

var original_modulate : Color
var editor_interface
var label_child : Button

func _enter_tree() -> void:
	editor_interface = EditorInterface.get_editor_main_screen()
	original_modulate = editor_interface.modulate
	editor_interface.modulate = Color.DEEP_PINK
	
	label_child = preload("uid://c5vs6wmogj3mi").instantiate()
	editor_interface.add_child(label_child)

func _exit_tree() -> void:
	editor_interface.modulate = Color.WHITE
	label_child.free()
