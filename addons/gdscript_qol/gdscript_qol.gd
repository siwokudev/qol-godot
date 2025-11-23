@tool
extends EditorPlugin

const signal_function_auto_complete_path := "gdscript_qol/signal_function_auto_complete"

func _enable_plugin() -> void:
	EditorInterface.set_plugin_enabled(signal_function_auto_complete_path, true)

func _disable_plugin() -> void:
	EditorInterface.set_plugin_enabled(signal_function_auto_complete_path, false)
