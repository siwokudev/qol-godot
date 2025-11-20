@tool
extends EditorPlugin

var popup_button : Control

func _enter_tree() -> void:
	popup_button = preload("uid://44u1hu8lt1at").instantiate() as Control
	add_control_to_bottom_panel(popup_button, "Gitbash")
	

func _exit_tree() -> void:
	remove_control_from_bottom_panel(popup_button)
	if is_instance_valid(popup_button):
		popup_button.free()
