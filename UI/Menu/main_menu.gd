extends Control

func _on_play_pressed() -> void:
	SceneTransition._change_scene("res://UI/Menu/Location/locations.tscn")

func _on_shop_pressed() -> void:
	SceneTransition._transition($Shop.show)

func _on_settings_pressed() -> void:
	SceneTransition._transition($Settings.show)

func _on_puzzle_pressed() -> void:
	SceneTransition._change_scene("res://Puzzle/Selection/puzzle_selection.tscn") 
