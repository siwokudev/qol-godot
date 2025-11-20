@tool
extends EditorPlugin

var popup_button : Button
var container

func _enter_tree() -> void:
	container = CONTAINER_INSPECTOR_BOTTOM
	popup_button = preload("uid://44u1hu8lt1at").instantiate() as Button
	add_control_to_container(container, popup_button)
	

func _exit_tree() -> void:
	if is_instance_valid(popup_button):
		remove_control_from_container(container, popup_button)
		popup_button.free()
