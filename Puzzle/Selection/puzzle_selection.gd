extends Control
const PUZZLE_BUTTON = preload("uid://bb0n3ciwynvbc")

@onready var container: GridContainer = %SelectionContainer
var path : String = "res://Puzzle/Textures/"
var textures : Array
func _ready() -> void:
	textures = get_resources_in_folder()
	$PuzzleContainer/CenterContainer/VBoxContainer/GridContainer.update_coins.connect($MoneyLabel._update_coins)
	var i = 0
	for texture in textures:
		var button = PUZZLE_BUTTON.instantiate()
		button.pressed.connect(_start_puzzle.bind(i))
		button.text = str(i+1)
		container.add_child(button)
		i+=1

func _start_puzzle(i) -> void:
	$PuzzleContainer/CenterContainer/VBoxContainer/GridContainer._start(textures[i])
	SceneTransition._transition($PuzzleContainer.show)
func _on_back_pressed() -> void:
	SceneTransition._change_scene("res://UI/Menu/main_menu.tscn")
	
#region Get Textures
func get_resources_in_folder() -> Array:
	var resources: Array = []
	var dir = DirAccess.open(path)
	if dir == null:
		push_error("Cannot open directory: " + path)
		return resources

	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if !dir.current_is_dir():
			if file_name.ends_with(".png"):
				var res_path = path + file_name
				var res = load(res_path)  # shorthand for ResourceLoader.load()
				if res != null:
					resources.append(res)
		file_name = dir.get_next()
	dir.list_dir_end()
	return resources
#endregion
