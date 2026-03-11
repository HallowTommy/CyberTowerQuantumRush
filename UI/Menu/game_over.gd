extends Control
@onready var high_score: Label = %HighScore
@onready var score: Label = %Score
@onready var coins: Label = %Coins

func _update_data(s) -> void:
	var hs = Global.save_data.get("HighScore")
	if s > hs:
		hs = s
	high_score.text = str(hs)
	score.text = str(s)
	coins.text = str(int(s/10))
	var cur_money = Global.save_data.get("Money")
	Global.save_data.set("Money", s/10 + cur_money)
	Global.save_data.set("HighScore", hs)
	Global._save()
	$MoneyLabel._update_coins()
func _on_menu_pressed() -> void:
	SceneTransition._change_scene("res://UI/Menu/main_menu.tscn")

func _on_retry_pressed() -> void:
	SceneTransition._change_scene("res://Main/Game/main.tscn")
