extends Line2D

@onready var pendulum: Node2D = $".."
@export var length: float = 600.0
#@export var speed: int = 5000
var speed: int = 400
@export var max_speed: int = 600
@export var max_angle: float = PI/12 # radians (~28°)
@export var max_offset: float = 400
@export var x_offset: float = 400
var x : float = 0
var angle: float
var angular_velocity: float = 0.0
func _ready():
	angle = max_angle

func _process(delta):
	var adjusted_delta = delta * pendulum.speed_regulator
	if x > x_offset:
		speed = -max_speed
	elif x < -x_offset:
		speed = max_speed
	x = lerp(x, x + speed * adjusted_delta, delta * 12.0  * (1 + cos(angle)))

	var angular_acceleration = -(5000 / length) * sin(angle)
	angular_velocity += angular_acceleration * adjusted_delta
	
	angle += angular_velocity * adjusted_delta
	#angle = clamp(angle, -max_angle, max_angle)
	update_line()

func update_line():
	var end_pos = Vector2(
		x,
		sin(angle) * max_offset
	)

	points = [Vector2.ZERO, end_pos]
	#get_parent().get_parent()._update_hook()
