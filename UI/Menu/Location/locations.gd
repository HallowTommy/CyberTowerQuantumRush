extends Control

@onready var locations: HBoxContainer = %Locations
@onready var locations_container: ScrollContainer = %LocationsContainer
const LOCATION = preload("uid://b28l8gujf6nxv")

var items_count : int 
var scrollable_range : float
var offset : float
var is_playing : bool = false
var scene_index = 0
var locations_arr : Array = [
	[preload("res://Locations/Location1.png"), "res://Main/Game/main.tscn"], # [ Texture , Location Scene Path]
	
	# COMING SOON LOCATION
	[preload("res://Locations/ComingSoon.png"), ""],
]

func _ready() -> void:
	_update_items()
	
func _on_right_arrow_pressed() -> void:
	if is_playing: return
	if scene_index < locations_arr.size() - 1:
		scene_index += 1
	is_playing = true
	var tween = _create_tween()
	var current_scroll_horizontal = locations_container.scroll_horizontal
	var target_scroll_horizontal = max(current_scroll_horizontal + offset,0.0)
	tween.tween_property(locations_container, "scroll_horizontal", target_scroll_horizontal, 0.7)
	await tween.finished
	is_playing = false
func _on_left_arrow_pressed() -> void:
	if is_playing: return
	if scene_index > 0:
		scene_index -= 1
	is_playing = true
	var tween = _create_tween()
	var current_scroll_horizontal = locations_container.scroll_horizontal
	var target_scroll_horizontal = max(current_scroll_horizontal - offset,0.0)
	tween.tween_property(locations_container, "scroll_horizontal", target_scroll_horizontal, 0.7)
	await tween.finished
	is_playing = false

func _create_tween() -> Tween:
	var tween = create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	return tween


func _update_items() -> void:
	var i : int = 0 
	for location in locations_arr:
		var item := LOCATION.instantiate()
		if i == 0:
			item._set_margins(180)
		elif i == locations_arr.size() - 1:
			item.get_node("ComingSoon!").show()
			item._set_margins(90,180)
		else:
			item._set_margins()
		locations.add_child(item)
		item._update_texture(location[0])
		i += 1
		await get_tree().process_frame
	await get_tree().process_frame
	items_count = locations.get_child_count()
	scrollable_range = locations.size.x - locations_container.size.x
	offset = scrollable_range / (items_count - 1)
	offset = 904.0

func _on_back_pressed() -> void:
	SceneTransition._change_scene("res://UI/Menu/main_menu.tscn")

func _on_enter_pressed() -> void:
	var scene_path : String = locations_arr[scene_index][1]
	if scene_path.length() == 0: return
	SceneTransition._change_scene(locations_arr[scene_index][1])
