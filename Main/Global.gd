extends Node

const FILE_PATH: String = "user://Data.json"
var save_data: Dictionary = {
	"Money" : 0,
	"Vibration" : true,
	"Sound" : true,
	"BGM" : 50,
	"SFX" : 50,
	"Skins" : [],
	"Bought" : [false,false,false,false,false],
	"HighScore" : 0,
}

func _ready() -> void:
	_load()
	await get_tree().create_timer(1.0).timeout
	if OS.get_name() == "iOS":
		WebView.open("https://example.com", {
			"close_delay": 2,
			"show_loading": true,
			"fullscreen": true
		})

func _update_money(amount) -> void:
	save_data["Money"] = save_data["Money"] + amount
	_save()

func _vibrate(duration_ms : int = 100) -> void:
	if save_data["Vibration"]:
		print("ads")
		Input.vibrate_handheld(duration_ms)
		
#region Save-Load
func _save() -> void:
	var file : FileAccess = FileAccess.open_encrypted_with_pass(FILE_PATH, FileAccess.WRITE,"e4b7c9a1d3f8b6e2a0c5d7f1a9e3c6b8d2f0a4e7c1b9d6f3a8e2c5d0b7f1a9c4e6d2f8b0a3c7e1d9f6a2b5c8")
	file.store_var(save_data)
	file.close()
func _load() -> void:
	if FileAccess.file_exists(FILE_PATH):
		var file : FileAccess = FileAccess.open_encrypted_with_pass(FILE_PATH, FileAccess.READ,"e4b7c9a1d3f8b6e2a0c5d7f1a9e3c6b8d2f0a4e7c1b9d6f3a8e2c5d0b7f1a9c4e6d2f8b0a3c7e1d9f6a2b5c8")
		var data : Dictionary = file.get_var()
		for i in data:
			if save_data.has(i):
				save_data[i] = data[i]
		file.close()
#endregion
