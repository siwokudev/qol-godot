@tool
extends EditorPlugin

var script_editor: ScriptEditor
var code_edit : CodeEdit

func _enter_tree() -> void:
	connect_script_editor()
	
func _exit_tree() -> void:
	disconnect_code_edit()
	disconnect_script_editor()
	
func connect_code_edit() -> void:
	code_edit = script_editor.get_current_editor().get_base_editor()
	if code_edit.get_signal_connection_list("code_completion_requested").size() > 1: 
		#needd to avoid multiple connections when is a child plugin
		return
	if code_edit && !code_edit.code_completion_requested.is_connected(_on_code_completition_requested):
		code_edit.code_completion_requested.connect(_on_code_completition_requested)

func disconnect_code_edit() -> void:
	if code_edit == null:
		return
	if code_edit.code_completion_requested.is_connected(_on_code_completition_requested):
		code_edit.code_completion_requested.disconnect(_on_code_completition_requested)

func connect_script_editor() -> void:
	script_editor = EditorInterface.get_script_editor()
	if script_editor && !script_editor.editor_script_changed.is_connected(_on_editor_script_changed):
		script_editor.editor_script_changed.connect(_on_editor_script_changed)
	
func disconnect_script_editor() -> void:
	if script_editor.editor_script_changed.is_connected(_on_editor_script_changed):
		script_editor.editor_script_changed.disconnect(_on_editor_script_changed)
		
func _on_editor_script_changed(script : Script) -> void:
	disconnect_code_edit()
	connect_code_edit()
	
func _on_code_completition_requested() -> void:
	var line := code_edit.get_caret_line()
	var text := code_edit.get_line(line)	
	signal_completition_check(text)
	void_function_completition_check(text)

func show_autocomplete_option(autocomplete : String, icon : Array[String]) -> void:
	code_edit.add_code_completion_option(CodeEdit.KIND_FUNCTION, 
			autocomplete, 
			autocomplete, 
			Color("d1d1d1ff"),
			EditorInterface.get_editor_theme().get_icon(icon[0],icon[1])
			)
	await get_tree().process_frame
	code_edit.request_code_completion(false)

func void_function_completition_check(text : String) -> void:
	var regex := RegEx.new()
	regex.compile("^\\s*func\\s+(\\w+)")
	var is_autocomplete := regex.search(text)
	if is_autocomplete:
		var function_name = is_autocomplete.get_string(1)
		var autocomplete := "%s() -> void:" % function_name
		show_autocomplete_option(autocomplete, ["MemberMethod", "EditorIcons"])

func signal_completition_check(text : String) -> void:
	var regex := RegEx.new()
	regex.compile("\\b\\w+(?:\\.\\w+)*\\.connect\\(\\s*(_?\\w+)")
	var result := regex.search(text)
	if result:
		var handler_name := result.get_string(1)  # preserves leading underscore
		var splited_text := result.get_string().split(".")
		var autocomplete := ""
		if splited_text.size() > 2:
			var signal_name := splited_text[splited_text.size() - 2]
			var node_name := splited_text[splited_text.size() - 3]
			autocomplete = "on_%s_%s" % [node_name, signal_name]
		else:
			var signal_name := splited_text[splited_text.size() - 2]
			autocomplete = "on_%s" % [ signal_name]
		if handler_name.begins_with("_"):
				autocomplete = "_" + autocomplete
		show_autocomplete_option(autocomplete, ["Callable", "EditorIcons"])
