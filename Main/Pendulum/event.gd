extends Node

@onready var time: Label = $CanvasLayer/Health/Time
@onready var event_timer: Timer = $EventTimer
@onready var label: Label = $CanvasLayer/Label
var events : Array[Callable] = [_sped_up,_earthquake,_triple_score,_zoom_out,_flipped_rotation]
var event_count : int = 3

func _process(_delta: float) -> void:
	if event_timer.is_stopped(): return
	var seconds : int = int(event_timer.time_left) % 60
	time.text =  str(seconds)

func _on_event_timer_timeout() -> void:
	await _event() 

func _event() -> void:
	$AnimationPlayer.play("announce")
	await events.pick_random().call()

func _earthquake() -> void:
	_update_event("Earthquake", 3)
	var camera = get_parent().get_node("Camera")
	while event_count > 0:
		camera.add_trauma(1.0)
		await get_tree().process_frame
func _triple_score() -> void:
	_update_event("x3 Score", 3)
	get_parent().score_multiplier = 3
func _flipped_rotation() -> void:
	_update_event("Flipped Rotation", 3)
	get_parent().rotation_direction = -1
func _sped_up() -> void:
	_update_event("Sped up", 3)
	Engine.time_scale = 1.1
func _zoom_out() -> void:
	_update_event("Zoom Out", 3)
	var camera = get_parent().get_node("Camera")
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(camera, "zoom", Vector2(0.75,.75), 2.0)

func _update_event(_name, count) -> void:
	_update_label(_name)
	event_count = count
	time.text = str(count) + "x"
	_update_timer()

func _update_timer() -> void:
	time.text = str(event_count) + "x"
	if event_count == 0: 
		event_timer.start()
		var camera = get_parent().get_node("Camera")
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property(camera, "zoom", Vector2(1,1), 1.2)
		get_parent().score_multiplier = 1
		get_parent().rotation_direction = 1
		Engine.time_scale = 1.0

func _update_label(text : String) -> void:
	label.text = text
