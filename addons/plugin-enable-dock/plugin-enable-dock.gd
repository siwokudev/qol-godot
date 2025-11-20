@tool
extends EditorPlugin

var plugins_menu_scene

func _enter_tree() -> void:
	#var editor = EditorInterface.get_editor_main_screen()
	plugins_menu_scene = preload("uid://c1bcty1keq5wj").instantiate() as Control
	#editor.add_child(plugins_menu_scene)
	add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_BL, plugins_menu_scene)

func _exit_tree() -> void:
	remove_control_from_docks(plugins_menu_scene)
	if plugins_menu_scene:
		plugins_menu_scene.free()
