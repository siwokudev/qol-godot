@tool
extends EditorPlugin

var script_editor: ScriptEditor
var code_edit : CodeEdit

func _enter_tree() -> void:
	connec_to_current_sritp_editor()
	
func _exit_tree() -> void:
	disconnect_all()
		
func connec_to_current_sritp_editor() -> void:
	script_editor = EditorInterface.get_script_editor()
	code_edit = script_editor.get_current_editor().get_base_editor()
	
	script_editor.editor_script_changed.connect(_on_editor_script_changed)
	code_edit.caret_changed.connect(_on_caret_changed)
	
func disconnect_all() -> void:
	if code_edit.caret_changed.is_connected(_on_caret_changed):
		code_edit.caret_changed.disconnect(_on_caret_changed)
	
	if script_editor.editor_script_changed.is_connected(_on_editor_script_changed):
		script_editor.editor_script_changed.disconnect(_on_editor_script_changed)

func _on_editor_script_changed(script : Script) -> void:
	disconnect_all()
	connec_to_current_sritp_editor()

func _on_caret_changed() -> void:
	void_func_completition()

func void_func_completition() -> void:
	var line := code_edit.get_caret_line()
	var text := code_edit.get_line(line)
	var void_func_text_index := text.find("():")
	
	var regex := RegEx.new()
	regex.compile("(?<![A-Za-z_])func(?![A-Za-z_])")
	var is_function_or_lambda := regex.search(text)
	
	if is_function_or_lambda && void_func_text_index != -1:
		code_edit.start_action(TextEdit.ACTION_DELETE)
		code_edit.remove_text(line, void_func_text_index,line, void_func_text_index + 3)
		code_edit.end_action()
		code_edit.start_action(TextEdit.ACTION_TYPING)
		code_edit.insert_text("() -> void:", line, void_func_text_index)
		code_edit.end_action()
