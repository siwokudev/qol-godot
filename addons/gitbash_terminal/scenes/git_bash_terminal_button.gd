@tool
extends Control

@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var terminal_line_edit: LineEdit = %TerminalLineEdit
@onready var launch_button: Button = %LaunchButton

@onready var clear: Button = %clear
@onready var status_button: Button = %StatusButton
@onready var add_button: Button = %AddButton
@onready var diff_button: Button = %DiffButton
@onready var log_button: Button = %LogButton
@onready var ammend_button: Button = %AmmendButton


var clear_commands := ["cls", "clear"]

var colors := {
	"danger": Color(1.0, 0.32, 0.32, 1.0),
	"warning" : Color(1.0, 0.909, 0.32, 1.0),
	"good" : Color(0.32, 1.0, 0.513, 1.0),
	"command" : Color(0.32, 0.796, 1.0, 1.0),
	"diff_file" : Color(1.0, 1.0, 1.0, 1.0),
	"current_branch" : Color(0.706, 0.57, 1.0, 1.0),
}

func _ready() -> void:
	ammend_button.pressed.connect(func() -> void: execute_command("commit --amend --no-edit"))
	clear.pressed.connect(func() -> void: execute_command("cls"))
	status_button.pressed.connect(func() -> void: execute_command("status"))
	add_button.pressed.connect(func() -> void: execute_command("add -A"))
	diff_button.pressed.connect(func() -> void: execute_command("diff"))
	log_button.pressed.connect(func() -> void: execute_command("log --reverse"))
	
	launch_button.pressed.connect(_on_launch_terminal_pressed)
	terminal_line_edit.text_submitted.connect(_on_terminal_line_edit_text_submited)
	
	terminal_line_edit.caret_blink = true
	terminal_line_edit.keep_editing_on_text_submit = true
	rich_text_label.scroll_following = true
	
	terminal_line_edit.placeholder_text = get_current_branch()

func execute_command(command : String) -> void:
	if clear_commands.has(command):
		rich_text_label.text = ""
		return
		
	command = command.replacen("git ", "")
	rich_text_label.text += replace( "executed git " + command, "(?m)^.*$", colors.command, true, 0, 2)
	var output = execute(command)
	
	for message in output:
		rich_text_label.text += preetify_output_text(message)
	rich_text_label.text += "\n\n "

func execute(command : String) -> Array:
	var output := []
	var exit_code := OS.execute("git", command.split(" "), output, true)
	if exit_code != Error.OK:
		printerr("Gitbash plugin - error executing command: " + command)
		output = ["error executing command: " + command]
	return output

func get_current_branch() -> String:
	var output := []
	output =execute("branch --show-current")
	if output.size() > 0:
		return "On branch " + output[0]
	return "gir project not extarted: use 'git init' or 'init' "

func preetify_output_text(text : String) -> String:
	text = replace(text, "(?m)^error .*$", colors.danger)
	text = replace(text, "(?m)^On branch.*$", colors.current_branch, true)
	text = replace(text, "(?m)^\tdeleted:", colors.danger)
	text = replace(text, "(?m)^\tmodified:", colors.warning)
	text = replace(text, "(?m)^added for commit:", colors.danger)
	text = replace(text, "(?m)^Changes to be committed:", colors.warning)
	text = replace(text, "(?m)^Changes not staged for commit:", colors.danger)
	text = replace(text, "(?m)^commit [0-9A-Za-z]+$", colors.warning)
	text = replace(text, "(?m)^-(?!-)(.*)$", colors.danger)
	text = replace(text, "(?m)^\\+(?!\\+)(.*)$", colors.good)
	text = replace(text, "(?m)^diff.*$", colors.diff_file, true, 1, 1)
	text = replace(text, "@@(.*?)@@", colors.command, false, 0, 1)
	
	return text

func replace(text : String, regex_string : String, color : Color, bold : bool = false, leading_line_feed : int = 0, trailing_line_feed : int = 0) -> String:
	var color_string := color.to_html(false)
	var regex = RegEx.new()
	regex.compile(regex_string)
	var new_format = "[color=#"+color_string+"]"+"$0[/color]"
	if bold:
		new_format = "[b]" + new_format + "[/b]"
	
	if leading_line_feed > 0:
		for i in leading_line_feed:
			new_format = "\n" + new_format
			
	if trailing_line_feed > 0:
		for i in trailing_line_feed:
			new_format = new_format + "\n"

	var result = regex.sub(text, new_format, true)
	if result:
		return result
	return text
	

func _on_terminal_line_edit_text_submited(new_text: String) -> void:
	execute_command(new_text)
	terminal_line_edit.clear()

func _on_launch_terminal_pressed() -> void:
	var path: String = ProjectSettings.globalize_path("res://")
	var command: String = 'cd %s  && start "" "C:\\Program Files\\Git\\bin\\sh.exe" && exit' % path
	OS.create_process("cmd.exe", ["/c", command], true)
