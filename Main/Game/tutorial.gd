extends CanvasLayer

func _on_close_pressed() -> void:
	set_physics_process(false)
	set_process(false)
	SceneTransition._transition(hide)
	await get_tree().create_timer(1.0).timeout
	get_parent().get_node("Pendulum")._start()
