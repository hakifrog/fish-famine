extends CanvasLayer

@onready var control = $Control



func _on_start_buttom_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_scene.tscn")


func _on_quit_button_pressed():
	get_tree().quit()


func _on_credits_button_pressed():
	pass # Replace with function body.
