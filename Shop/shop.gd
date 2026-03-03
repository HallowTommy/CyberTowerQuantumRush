extends Control

@onready var shop_container: ScrollContainer = %ShopContainer
@onready var shop_items: HBoxContainer = %ShopItems

var items_count : int 
var scrollable_range : float
var offset : float
var is_playing : bool = false

func _ready() -> void:
	_update_items()
	shop_items._update_money.connect($MoneyLabel._update_coins)
func _on_right_arrow_pressed() -> void:
	if is_playing: return
	is_playing = true
	var tween = _create_tween()
	var current_scroll_horizontal = shop_container.scroll_horizontal
	var target_scroll_horizontal = max(current_scroll_horizontal + offset,0.0)
	tween.tween_property(shop_container, "scroll_horizontal", target_scroll_horizontal, 0.7)
	await tween.finished
	is_playing = false

func _on_left_arrow_pressed() -> void:
	if is_playing: return
	is_playing = true
	var tween = _create_tween()
	var current_scroll_horizontal = shop_container.scroll_horizontal
	var target_scroll_horizontal = max(current_scroll_horizontal - offset,0.0)
	tween.tween_property(shop_container, "scroll_horizontal", target_scroll_horizontal, 0.7)
	await tween.finished
	is_playing = false

func _create_tween() -> Tween:
	var tween = create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	return tween
const SHOP_ITEM = preload("uid://ba4s0lpws24lr")

var path = "res://Main/TowerSkins/"
func _update_items() -> void:
	var tower_skins : Array[TowerSkin] = get_resources_in_folder()
	var i : int = 0 
	for tower_skin in tower_skins:
		var item := SHOP_ITEM.instantiate()
		if i == 0:
			item._set_margins(180)
		elif i == tower_skins.size() - 1:
			item._set_margins(90,180)
		else:
			item._set_margins()
		shop_items.add_child(item)
		item.skin = tower_skin
		item.index = i
		item._update_data()
		shop_items.move_child(%ComingSoon, shop_items.get_child_count() - 1)
		#if Global.save_data.get("Shop")[i]:
			#item._update()
		i += 1
		await get_tree().process_frame
	await get_tree().process_frame
	items_count = shop_items.get_child_count()
	scrollable_range = shop_items.size.x - shop_container.size.x
	offset = scrollable_range / (items_count - 1)
	offset = 904.0
#region Get files from folder
func get_resources_in_folder() -> Array[TowerSkin]:
	var resources: Array[TowerSkin] = []
	var dir = DirAccess.open(path)
	if dir == null:
		push_error("Cannot open directory: " + path)
		return resources

	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if !dir.current_is_dir():
			if file_name.ends_with(".tres"):
				var res_path = path + file_name
				var res = load(res_path)  # shorthand for ResourceLoader.load()
				if res != null:
					resources.append(res)
		file_name = dir.get_next()
	dir.list_dir_end()
	return resources
#endregion


func _on_back_pressed() -> void:
	SceneTransition._transition(hide)
