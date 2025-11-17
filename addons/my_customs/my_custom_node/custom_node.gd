@tool
extends EditorPlugin

func _enter_tree() -> void:
	add_custom_type("MyButton", 
		"Button", 
		preload("uid://ct3xf3inls4sj"), 
		preload("uid://dpxy54krq4wby"))


func _exit_tree() -> void:
	remove_custom_type("My_Button")
