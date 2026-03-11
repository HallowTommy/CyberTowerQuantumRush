extends CanvasLayer

@onready var score: Label = %Score
@onready var hp_container: HBoxContainer = %HpContainer
func _ready() -> void:
	for hp in hp_container.get_children():
		var material = hp.material as ShaderMaterial
		material.set_shader_parameter("grayscale_strength", 0.0)

func _update_health(health) -> void:
	var hp = hp_container.get_child(health)
	var material = hp.material
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(material,"shader_parameter/grayscale_strength",1.0,1.0)
func _update_score(score_amount) -> void:
	score.text = "Score | " + str(score_amount)


func _on_settings_pressed() -> void:
	SceneTransition._transition($"../CanvasLayer2/Settings".show)


func _on_home_pressed() -> void:
	SceneTransition._change_scene("res://UI/Menu/main_menu.tscn")
