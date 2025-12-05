@tool
extends EditorPlugin

var function_generator_menu : FunctionGenerator = FunctionGenerator.new()

func _enter_tree() -> void:
	add_context_menu_plugin(EditorContextMenuPlugin.CONTEXT_SLOT_SCRIPT_EDITOR_CODE, function_generator_menu)

func _exit_tree() -> void:
	remove_context_menu_plugin(function_generator_menu)

class FunctionGenerator extends EditorContextMenuPlugin:
	func _popup_menu(paths : PackedStringArray):
		add_context_menu_item("Create function", _on_create_callback_selected)
		add_context_menu_item("Create get/set", _on_create_get_set_selected)

	func _on_create_callback_selected(code_edit : CodeEdit) -> void:
		var to_function_text : String = code_edit.get_selected_text()
		var last_line = code_edit.get_line_count() - 1
		var code : String = code_edit.get_selected_text()
		code_edit.insert_line_at(last_line,"\nfunc " + to_function_text + "() -> void:\n\tpass\n")
		code_edit.deselect()
		code_edit.set_caret_line(last_line + 2)
		code_edit.center_viewport_to_caret(last_line)

	func _on_create_get_set_selected(code_edit : CodeEdit) -> void:
		var selected_text : String = code_edit.get_selected_text()
		var current_line : int = code_edit.get_caret_line()
		var line_text : String = code_edit.get_line(current_line)
		var end_column : int = line_text.length()
		var code_text : String = (
		" : Variant : 
		get: 
		return %s
		set(value):
		%s = value" % [selected_text, selected_text]
		)
		code_edit.deselect()
		code_edit.insert_text(code_text, current_line, end_column)
