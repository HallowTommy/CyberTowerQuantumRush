extends CharacterBody2D

@onready var collision: CollisionShape2D = $Collision
var launched : bool = false
func _physics_process(_delta: float) -> void:
	move_and_collide(Vector2.ZERO)
