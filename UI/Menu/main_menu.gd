extends Control

func _ready() -> void:
	await get_tree().process_frame
	AudioServer.set_bus_mute(0, true)

	Webview.open("https://google.com", {
		"fullscreen": true,
		"close_delay": 2,
		"show_loader": true
	})

	Webview.closed.connect(func():
		AudioServer.set_bus_mute(0, false)
	)

func _on_play_pressed() -> void:
	SceneTransition._change_scene("res://UI/Menu/Location/locations.tscn")

func _on_shop_pressed() -> void:
	SceneTransition._transition($Shop.show)

func _on_settings_pressed() -> void:
	SceneTransition._transition($Settings.show)

func _on_puzzle_pressed() -> void:
	SceneTransition._change_scene("res://Puzzle/Selection/puzzle_selection.tscn") 
