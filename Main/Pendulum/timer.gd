extends Timer

@onready var control: Control = $CanvasLayer/Control

func _start(_time) -> void:
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(control, "modulate:a", 1.0, .5)
	wait_time = _time
	start()
	%ProgressBar.max_value = _time
	set_process(true)

func _process(_delta: float) -> void:
	if is_stopped() : return
	%ProgressBar.value = clamp(time_left, 0.1, wait_time)
func _on_timeout() -> void:
	set_process(false)
	%ProgressBar.value = 0.1
	get_parent().is_rotating = false
	get_parent().current_tower.rotating = false
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(control, "modulate:a", 0.0, .5)
