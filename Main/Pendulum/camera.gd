extends Camera2D

@export var max_offset : float = 25.0
@export var max_rotation : float = 5.0
@export var trauma_decay : float = 1.5
@export var trauma_power : float = 2.0

var trauma : float = 0.0
var noise := FastNoiseLite.new()
var noise_y := 0.0

func _ready() -> void:
	noise.seed = randi()
	noise.frequency = 10.0

func _process(delta) -> void:
	if trauma > 0:
		trauma = max(trauma - trauma_decay * delta, 0)
		shake()

func add_trauma(amount: float) -> void:
	trauma = clamp(trauma + amount, 0.0, 1.0)

func shake() -> void:
	var shake_amount = pow(trauma, trauma_power)
	noise_y += 1.0

	offset.x = max_offset * shake_amount * noise.get_noise_2d(0, noise_y)
	offset.y = max_offset * shake_amount * noise.get_noise_2d(100, noise_y)

	rotation_degrees = max_rotation * shake_amount * noise.get_noise_2d(200, noise_y)
	
func _zoom() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "zoom", Vector2(1.09,1.09), 0.1)
	tween.tween_property(self, "zoom", Vector2(.92,.92), 0.2)
	tween.tween_property(self, "zoom", Vector2(1,1), 0.1)
