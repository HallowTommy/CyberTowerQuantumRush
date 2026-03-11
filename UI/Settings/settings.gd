extends VBoxContainer
@onready var settings: Control = $"../.."

@onready var sfx: HSlider = $SFX
@onready var bgm: HSlider = $BGM
func _ready() -> void:
	Global._load()
	sfx.value = Global.save_data["SFX"]
	bgm.value = Global.save_data["BGM"]
	%Vibration.button_pressed = Global.save_data["Vibration"]
	%Audio.button_pressed = Global.save_data["Sound"]
	
func _on_sfx_value_changed(value: float) -> void:
	var t = pow(value / 100.0, 2)  # makes low values quieter faster
	var db = lerp(-20,16, t)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), db)

func _on_bgm_value_changed(value: float) -> void:
	var t = pow(value / 100.0, 2)  # makes low values quieter faster
	var db = lerp(-20, 16, t)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"), db)

func _vibration_toggled(toggled_on: bool) -> void:
	Global.save_data["Vibration"] = toggled_on
	Global._save()
	
func _mute_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), !toggled_on)
	Global.save_data["Sound"] = toggled_on
	Global._save()

func _on_back_pressed() -> void:
	Global.save_data["BGM"] = bgm.value
	Global.save_data["SFX"] = sfx.value
	Global._save()
	SceneTransition._transition(settings.hide)
