extends Node

func _ready() -> void:
	var button := Button.new()
	button.pressed.connect(on_button_pressed)

func on_button_pressed() -> void:
	pass
