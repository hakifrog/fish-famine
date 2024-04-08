extends CanvasLayer

@onready var control = $Control
@onready var buttonFocusedSFX = $Sound/ButtonFocused
@onready var buttonPressedSFX = $Sound/ButtonPressed
@onready var soundtrack = $Sound/Soundtrack

@onready var creditsNode = $Credits

func _ready():
	creditsNode.visible = false
	soundtrack.play()

func _on_start_buttom_pressed():
	await _play_selection_sfx()
	BubbleTrans.change_scene("res://Scenes/main_scene.tscn")

func _on_quit_button_pressed():
	await _play_selection_sfx()
	get_tree().quit()

func _on_credits_button_pressed():
	await _play_selection_sfx()
	creditsNode.visible = true

func _on_back_button_pressed():
	await _play_selection_sfx()
	creditsNode.visible = false

func _on_button_mouse_entered():
	buttonFocusedSFX.play()

func _play_selection_sfx():
	buttonPressedSFX.play()
	await buttonPressedSFX.finished
