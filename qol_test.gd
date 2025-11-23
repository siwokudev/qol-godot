extends Node

func _ready() -> void:
	tree_entered.connect(func() -> void: print("site"))
