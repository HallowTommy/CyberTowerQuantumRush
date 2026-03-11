extends MarginContainer

var skin : TowerSkin
@onready var button: Button = %Buy
@onready var item_name: Label = %Name
@onready var texture: TextureRect = %Texture
@onready var cost: Label = %Cost
@onready var info: RichTextLabel = %Info
var index : int = 0
var bought : bool = false
var equipped : bool = false

func _ready() -> void:
	Global._load()
	if Global.save_data.get("Bought")[index]:
		_update()
		await get_tree().process_frame
		bought = true
		cost.text = "Unlocked"

func _update_data() -> void:
	item_name.text = skin.item_name
	texture.texture = skin.texture
	cost.text = str(skin.cost)
	info.text = skin.info

func _set_margins(left : int = 90,right : int = 90) -> void:
	add_theme_constant_override("margin_left", left)
	add_theme_constant_override("margin_right", right)

func _on_buy_pressed() -> void:
	if bought:
		return
	var current_money = Global.save_data.get("Money")
	if current_money >= skin.cost:
		var _bought = Global.save_data.get("Bought")
		_bought[index] = true
		var current_skins = Global.save_data.get("Skins")
		Global.save_data.set("Money", current_money - skin.cost)
		Global.save_data.set("Bought", _bought)
		
		current_skins.append([skin.texture.get_path(),skin.chance,skin.score])
		Global.save_data.set("Skins", current_skins)
		get_parent()._update_money.emit()
		_update()
		cost.text = "Unlocked"
		Global._save()
		bought = true

func _update() -> void:
	var tex : StyleBoxTexture = StyleBoxTexture.new()
	tex.texture = load("res://UI/Sprites/ButtonPressed.png")
	button.add_theme_stylebox_override("hover",tex)
	button.add_theme_stylebox_override("normal",tex)
	button.add_theme_stylebox_override("pressed",tex)
	cost.text = "Unlocked"
