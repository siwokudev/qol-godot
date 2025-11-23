@tool
extends Control

func _ready() -> void:
	for child in get_children():
		child.queue_free()
	var icon_types := EditorInterface.get_editor_theme().get_icon_type_list()
	
	var index := 1
	 
	for type in icon_types:
		var icons := EditorInterface.get_editor_theme().get_icon_list(type)
		for icon in icons:
			var icon_svg = EditorInterface.get_editor_theme().get_icon(icon, type)
			var scale_modifier : Vector2 = (icon_svg.get_size() / 16)
			var icon_sprite := Sprite2D.new()
			icon_sprite.texture = icon_svg
			icon_sprite.name = icon + " " + type
			icon_sprite.global_position.x += 32 * (index % 35)
			icon_sprite.global_position.y += 32 * (index / 35)
			icon_sprite.scale /= max(scale_modifier.x, scale_modifier.y)
			add_child(icon_sprite)
			icon_sprite.owner = get_tree().edited_scene_root
			index += 1
