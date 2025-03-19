extends Control


func _on_play_button_pressed():
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")

func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/credits_screen.tscn")
