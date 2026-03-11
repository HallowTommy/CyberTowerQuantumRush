extends Node2D
@onready var bg: TextureRect = %BG

@onready var pendulum: Node2D = $Pendulum
@export var max_health : int = 3
var health : int
var score : int = 0
func _ready() -> void:
	health = max_health
	pendulum.failed.connect(_failed)
	_change_score(0)

func _failed() -> void:
	pendulum.speed_regulator = 2.0
	pendulum.speed_up = true
	health -= 1
	if health <= 0: 
		health = 0
		_game_over()
	$UI._update_health(health)

func _change_score(change_amount) -> void:
	score += change_amount
	$UI._update_score(score)

func _game_over() -> void:
	$Pendulum.can_play = false
	SceneTransition._transition(%GameOver.show)
	%GameOver._update_data(score)
