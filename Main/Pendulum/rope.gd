extends Line2D

@onready var pendulum: Node2D = $"../.."
@export var length: float = 600.0
@export var speed: int = 5000
@export var max_angle: float = PI/12 # radians (~28°)

var angle: float
var angular_velocity: float = 0.0
func _ready():
	angle = max_angle

func _process(delta):
	var adjusted_delta = delta * pendulum.speed_regulator
	var angular_acceleration = -(speed / length) * sin(angle)
	angular_velocity += angular_acceleration * adjusted_delta
	angle += angular_velocity * adjusted_delta
	angle = clamp(angle, -max_angle, max_angle)
	update_line()

func update_line():
	var end_pos = Vector2(
		sin(angle) * length,
		cos(angle) * length
	)

	points = [Vector2.ZERO, end_pos]
	get_parent().get_parent()._update_hook()
