@tool
extends HBoxContainer

@onready var v_box_container: VBoxContainer = %VBoxContainer

func _ready() -> void:
	add_plugin_control()
	
func add_plugin_control() -> void:
	var plugins := get_all_plugins()
	for plugin in plugins:
		var boxContainer := HBoxContainer.new()
		var checkbox_button := CheckBox.new()
		checkbox_button.set_pressed_no_signal(is_plugin_enabled(plugin))
		
		var reload_button := Button.new()
		reload_button.text = "Reload"
		reload_button.pressed.connect(_on_reload_button_pressed.bind(plugin))
		boxContainer.add_child(reload_button)
		
		checkbox_button.toggled.connect(_on_toggled_checkbutton.bind(plugin))
			
		boxContainer.add_child(checkbox_button)
		
		var name_label := Label.new()
		name_label.text = plugin
		boxContainer.add_child(name_label)
		
		v_box_container.add_child(boxContainer)

func _on_reload_button_pressed(_name : String) -> void:
	if !is_plugin_enabled(_name):
		return
	disable_plugin(_name)
	await get_tree().create_timer(0.1).timeout
	enable_plugin(_name)

func _on_toggled_checkbutton(toggled_on: bool, plugin : String) -> void:
	if toggled_on:
		enable_plugin(plugin)
	else:
		disable_plugin(plugin)

func is_plugin_enabled(_name : String) -> bool:
	if (_name.length() != 0):
		return EditorInterface.is_plugin_enabled("res://addons/" + _name + "/plugin.cfg")
	return false

func enable_plugin(_name : String) -> void:
	EditorInterface.set_plugin_enabled("res://addons/" + _name + "/plugin.cfg", true)
	#print("enabled ", _name)
	
func disable_plugin(_name : String) -> void:
	EditorInterface.set_plugin_enabled("res://addons/" + _name + "/plugin.cfg", false)
	#print("disabled ", _name)

func get_all_plugins() -> Array:
	var plugins : Array = []
	var dir := DirAccess.open("res://addons")
	if dir:
		dir.list_dir_begin()
		var folder := dir.get_next()
		while folder != "":
			if dir.current_is_dir():
				var cfg_path := "res://addons/%s/plugin.cfg" % folder
				if FileAccess.file_exists(cfg_path):
					plugins.append(folder)
			folder = dir.get_next()
		dir.list_dir_end()
	return plugins
