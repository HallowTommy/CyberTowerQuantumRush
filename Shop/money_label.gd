extends Control
@onready var coins: Label = %Coins
func _ready() -> void:
	Global._load()
	_update_coins()
func _update_coins() -> void:
	var coins_amount = Global.save_data["Money"]
	coins.text = str(coins_amount)
