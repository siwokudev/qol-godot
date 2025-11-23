@tool
extends EditorPlugin

const PLUGIN_NAME = "gdscript_qol"

func _enable_plugin():
	EditorInterface.set_plugin_enabled(PLUGIN_NAME + "/void_function_autocomplete", true)

func _disable_plugin():
	EditorInterface.set_plugin_enabled(PLUGIN_NAME + "/void_function_autocomplete", false)
