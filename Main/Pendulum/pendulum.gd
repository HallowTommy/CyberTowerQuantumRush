extends Node2D
const RECTANGULAR_TOWER = preload("uid://ct184jov2bdg2")
const SQUARE_TOWER = preload("uid://c0telxdvglcxj")
const TALL_TOWER = preload("uid://bwq01i1p4g4g3")

@export var speed_regulator: float = 1.0
@onready var hook: Node2D = $Hook

@onready var main: Node2D = $".."
@onready var current_tower : CharacterBody2D
@onready var rope: Line2D = %Rope
@onready var camera: Camera2D = $Camera
@onready var particle: GPUParticles2D = $"../Perfect"
#var tower_scenes: Array[PackedScene] = []
var score_multiplier : int = 1
var speed_up : bool = false
var start_position_y : float = 0.0
var tower_position : Vector2 = Vector2.ZERO
var shake_offset_x : float = 0.0
var i : int = 0
var can_play : bool = true
@warning_ignore("unused_signal")
signal failed
var rotation_direction : int = 1
var time_passed := 0.0
@export var frequency := 1.0
var is_rotating : bool = true
var timer_wait_time := 3.0
func _ready() -> void:
	#tower_scenes = get_scenes("res://Main/Towers/")
	_spawn_tower()

func _process(delta: float) -> void:
	$Aura.global_position = rope.to_global(rope.get_point_position(1))
	$Aura.global_position.y += 600
	_update_tower()
	if not get_tree().paused:
		time_passed += delta * frequency
func _update_tower() -> void:
	if not current_tower or current_tower.launched: return
	tower_position = rope.to_global(rope.get_point_position(1))
	tower_position.y += 600
	current_tower.global_position = tower_position
	#current_tower.rotation = -rope.angle
func _update_hook() -> void:
	hook.global_position = rope.to_global(rope.get_point_position(1))
	hook.rotation = -rope.angle
func _spawn_tower() -> void:
	var tower : CharacterBody2D
	var k : float = randf()
	if k > .85:
		tower = TALL_TOWER.instantiate()
	elif k > .7:
		tower = RECTANGULAR_TOWER.instantiate()
	else:
		tower = _spawn_square_tower()
		
	$Towers.add_child(tower)
	current_tower = tower
	var rad = randf_range(-PI, PI)
	current_tower.rotation = rad
	current_tower.tar_rotation = rad
	current_tower.collided.connect(_update)
	$Timer._start(timer_wait_time)
	is_rotating = true
	tower.index = i
	i+=1
	_update_tower()
func disable_rotation(tower) -> void:
	if tower:
		tower.rotating = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.is_pressed() and current_tower and can_play and not is_rotating:
			current_tower.launched = true
			current_tower.collision.disabled = false
			current_tower = null
			$CD.start()
			$EventComponent.event_count -= 1
			$EventComponent._update_timer()
			
func _update(new_pos, size_y, is_perfect, score_amount : int, is_fall : bool = false) -> void:
	#PARTICLE TO CENTRE
	Global._vibrate()
	particle.global_position = new_pos
	particle.global_position.y += size_y/2
	var first_tower 
	if $Towers.get_child_count() > 0:
		first_tower = $Towers.get_child(0)
	else:
		first_tower = $Towers
	#CAMERA SHAKE
	$Camera.add_trauma(1.0)
	$Camera._zoom()
	if not is_fall:
		shake_offset_x = abs(new_pos.x - first_tower.global_position.x)
		shake_offset_x = remap(shake_offset_x, -300.0, 300.0, -PI/22, PI/22)
		#PERFECT HIT
		if is_perfect:
			particle.emitting = true
			main._change_score(score_amount * 2 * score_multiplier)
			$Award.play()
		else:
			main._change_score(score_amount * score_multiplier)
		
	#FIRST ATTEMPT
	if new_pos != global_position:
		new_pos.y = min(global_position.y, new_pos.y - 400)
	
	#TWEEN 
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT).set_parallel(true)
	tween.tween_property(self, "global_position:y", new_pos.y, 0.5)
	var delta_y = (global_position.y - new_pos.y)
	delta_y += get_parent().bg.global_position.y
	tween.tween_property(get_parent().bg, "global_position:y", delta_y, 0.5)

func _on_cd_timeout() -> void:
	_spawn_tower()

func _update_offsets() -> void:
	for tower in $Towers.get_children():
		tower.shake_offset = 0.0
#region Get Scenes From Folder
func get_scenes(folder_path: String) -> Array[PackedScene]:
	var result: Array[PackedScene] = []
	var dir = DirAccess.open(folder_path)

	dir.list_dir_begin()
	var file = dir.get_next()

	while file != "":
		if not dir.current_is_dir() and file.ends_with(".tscn"):
			result.append(load(folder_path + "/" + file))
		file = dir.get_next()

	return result
#endregion
func _spawn_square_tower() -> CharacterBody2D:
	var tower = SQUARE_TOWER.instantiate()
	var weights = [0]
	var whole_weight = 0
	var skins = Global.save_data["Skins"]
	for skin in skins:
		weights.append(skin[1])
		whole_weight += skin[1]
	weights[0] = 100 - whole_weight
	var random_value = randi_range(0,100)
	var index = 0
	for j in range(weights.size()):
		if random_value < weights[j]:
			index = j
			break
		random_value -= weights[j]
	if index == 0:
		var tex = load("res://Main/TowerTextures/square.png")
		tower._update_texture(tex)
	else:
		var tex = load(skins[index - 1][0])
		tower._update_texture(tex)
		tower.score_amount = skins[index-1][2]
		#print(tower.score_amount)
	return tower

func _on_deletor_body_entered(body: Node2D) -> void:
	if body.is_in_group("Stackable"):
		failed.emit()
		body.queue_free()
