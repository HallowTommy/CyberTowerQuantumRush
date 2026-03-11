extends CharacterBody2D

@onready var pendulum: Node2D = get_parent().get_parent()
@onready var collision: CollisionShape2D = $Collision
@export var speed : float = 300.0

signal collided

var launched : bool = false
var landed : bool = false
var target_position : Vector2
var target_angle : float = 0.0
var is_falling : bool = false
var shake : bool = false
var index : int = 0
var score_amount : int = 1

@export var damping := 0.995
var weight : float = 0.0
var shake_offset : float = 0.0
var rotating : bool = true 
var pressed : bool = false

var tar_rotation : float = 0.0
func _ready() -> void:
	collision.disabled = true
	
func _process(delta: float) -> void:
	if shake:
		var wave = sin(pendulum.time_passed)
		var height_ratio = min(float(index) / float(pendulum.get_node("Towers").get_child_count()), 12)
		var target_weight = pow(height_ratio, 1.003) # tweak 1.2–2.0
		weight = lerp(weight, target_weight, delta * 1.5)
		shake_offset = lerp(shake_offset, pendulum.shake_offset_x, delta * 2.5)
		target_angle = - shake_offset * weight * wave
		target_position = global_position.rotated(target_angle - global_rotation)
		global_rotation = lerp(global_rotation, target_angle, delta * 2.5)
		global_position = lerp(global_position, target_position, delta * 2.5)

func _physics_process(delta: float) -> void:
	if landed and not is_falling:
		#get_tree().paused = true
		#global_rotation = lerp(global_rotation, target_angle, delta * 35.0)
		#global_position = lerp(global_position, target_position, delta * 35.0)
		global_position = target_position
		global_rotation = target_angle
		if global_position.is_equal_approx(target_position) and roundf(global_rotation) == roundf(target_angle):
			#get_tree().paused = false
			pendulum._update_offsets()
			process_mode = Node.PROCESS_MODE_PAUSABLE
			landed = false
			shake = true
	elif rotating:
		rotation = lerp_angle(rotation, tar_rotation, delta * 12.0)
	if launched:
		velocity += get_gravity() * delta * 12

	var _collision = move_and_collide(velocity * delta)
	if not _collision: return
	var body = _collision.get_collider()
	if body.is_in_group("Stackable") and not landed:
		pendulum.get_node("Fall").play()
		landed = true
		process_mode = Node.PROCESS_MODE_ALWAYS
		_make_still(body)
		var normal = _collision.get_normal()
		var point = _collision.get_position()
		var is_perfect = false
		
		#ROTATION + POSITION
		target_angle = body.global_rotation
		target_position = point + (global_position - point).rotated(target_angle - global_rotation)
		
		#PERFECT CONDITION
		var body_offset = target_position - body.global_position
		if abs(body_offset.x) < 25.0:
			target_position.x = body.global_position.x
			is_perfect = true
			
		#FALLING CONDITION
		if (abs(normal.x) > 0.25 or
			abs(body_offset.x) > body.collision.shape.get_rect().size.x/2):
			_fall()
			collided.emit(pendulum.global_position, 0.0, false,0,true)
			return
		if pendulum.speed_up:
			pendulum.speed_regulator = 1.0
			pendulum.speed_up = false
		body.collision.disabled = true
		if body.name != "Floor":
			collided.emit(target_position, collision.shape.get_rect().size.y,is_perfect,score_amount)
		else:
			collided.emit(pendulum.global_position, 0.0,false,score_amount)

var previous_position : Vector2
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		pressed = event.pressed
		if pressed:
			previous_position = event.position
		else:
			previous_position = Vector2.ZERO
	if event is InputEventMouseMotion:
		if pressed and rotating and pendulum.is_rotating:
			var relative = event.position - previous_position
			var x = get_viewport_rect().size.x * 1.2
			tar_rotation += remap(relative.x, -x,x, -PI, PI) * pendulum.rotation_direction
			previous_position = event.position
			
			
func _fall() -> void:
	z_index = 1
	get_tree().paused = false
	reparent(pendulum)
	set_physics_process(true)
	launched = true
	collision.disabled = true
	is_falling = true
	pendulum.failed.emit()
	await get_tree().create_timer(2.0).timeout
	queue_free()
func _make_still(body) -> void:
	launched = false
	velocity = Vector2.ZERO
	body.set_physics_process(false)
	
func _update_texture(tex) -> void:
	#if not $Texture: return
	$Collision/Sprite.texture = tex
