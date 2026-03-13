extends CanvasLayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var can_transition : bool = true
func _ready() -> void:
WebView.open("https://example.com", {
    "close_delay": 5,         # кнопка ✕ появится через 5 сек
    "auto_dismiss": 30,       # закроется само через 30 сек
    "fullscreen": true,       # на весь экран
    "show_loading": true,     # крутилка пока грузит
})
	animation_player.play_backwards("Transition")
	await animation_player.animation_finished
	hide()
func _change_scene(scene_path : String) -> void:
	if not can_transition: return
	can_transition = false
	show()
	animation_player.play("Transition")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(scene_path)
	await get_tree().scene_changed
	animation_player.play_backwards("Transition")
	await animation_player.animation_finished
	hide()
	can_transition = true
	
func _transition(function : Callable) -> void:
	if not can_transition: return
	can_transition = false
	show()
	animation_player.play("Transition")
	await animation_player.animation_finished
	await function.call()
	animation_player.play_backwards("Transition")
	await animation_player.animation_finished
	hide()
	can_transition = true
