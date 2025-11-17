@tool
extends EditorPlugin

const PLUGIN_NAME = "my_customs"

func _enable_plugin() -> void:
	EditorInterface.set_plugin_enabled(PLUGIN_NAME + "/my_custom_dock", true)
	EditorInterface.set_plugin_enabled(PLUGIN_NAME + "/my_custom_node", true)


func _disable_plugin() -> void:
	EditorInterface.set_plugin_enabled(PLUGIN_NAME + "/my_custom_dock", false)
	EditorInterface.set_plugin_enabled(PLUGIN_NAME + "/my_custom_node", false)
