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
	var caret_current_line := code_edit.get_caret_line()
	var current_line := code_edit.get_line(caret_current_line)
	if current_line.contains("func") && current_line.contains("():"):
		current_line = current_line.replacen("():", "() -> void:")
		code_edit.set_line(caret_current_line, current_line)
		code_edit.set_caret_line(caret_current_line)
		code_edit.set_caret_column(999)
		code_edit.set_caret_column(current_line.length())
