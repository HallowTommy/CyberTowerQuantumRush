extends MarginContainer
@onready var texture: TextureRect = $Texture

func _update_texture(_texture) -> void:
	texture.texture = _texture
func _set_margins(left : int = 90,right : int = 90) -> void:
	add_theme_constant_override("margin_left", left)
	add_theme_constant_override("margin_right", right)
