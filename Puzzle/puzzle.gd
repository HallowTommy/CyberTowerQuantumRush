extends GridContainer
@onready var puzzle_container: Control = $"../../.."

var current_selected : TextureRect
var texture : Texture2D
var can_play : bool = true
func _ready() -> void:
	puzzle_container.hide()
func _start(tex) -> void:
	can_play = true
	texture = tex
	var arr = generate_random_array()
	var i : int = 0
	for piece in get_children():
		piece.texture = texture
		piece._set_id(arr[i])
		piece._unglow()
		i+=1
signal update_coins
func _select(piece : TextureRect) -> void:
	if not can_play : return
	if not current_selected:
		current_selected = piece
		current_selected._glow()
		return
	if piece == current_selected:
		piece._unglow()
		current_selected = null
		return
	elif current_selected:
		var id1 = piece._get_id()
		piece._set_id(current_selected._get_id())
		current_selected._set_id(id1)
		current_selected._unglow()
		piece._unglow()
		current_selected = null
		if _check_win():
			Global._update_money(3)
			update_coins.emit()
			puzzle_container.get_node("Award").play()
			can_play = false
func _check_win() -> bool:
	var i : int = 0
	for piece in get_children():
		if i != piece._get_id():
			return false
		i+=1
	return true
func generate_random_array() -> Array:
	var arr = [0,1,2,3,4,5,6,7,8]
	arr.shuffle()  # randomly shuffles the array
	return arr


func _on_back_pressed() -> void:
	SceneTransition._transition(puzzle_container.hide)
