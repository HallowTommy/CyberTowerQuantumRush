extends TextureRect

var shader : ShaderMaterial = material

func _glow() -> void:
	shader.set_shader_parameter("outline_thickness", 0.03)
func _unglow() -> void:
	shader.set_shader_parameter("outline_thickness", 0.0)
func _pressed() -> void:
	get_parent()._select(self)
func _set_id(data) -> void:
	shader.set_shader_parameter("id", data)
func _get_id() -> int:
	return shader.get_shader_parameter("id")
	
