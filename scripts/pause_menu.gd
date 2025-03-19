extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused=true
	$VBoxContainer/GridContainer/VBoxContainer/SoundSlider.value=Global.sound_effects_volume
	$VBoxContainer/GridContainer/VBoxContainer2/MusicSlider.value=Global.music_volume
	show()
	Input.mouse_mode=Input.MOUSE_MODE_CONFINED
	$VBoxContainer/GridContainer/ResumeButton.grab_focus()
	$VBoxContainer/FullscreenButton.button_pressed=Global.is_fullscreen


func _on_sound_slider_value_changed(value):
	Global.sound_effects_volume=value
	Global.update_sound_effect_volume()


func _on_music_slider_value_changed(value):
	Global.music_volume=value
	Global.update_music_volume()


func _on_resume_button_pressed():
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	get_tree().paused=false
	queue_free()


func _on_quit_button_pressed():
	get_tree().quit()


func _on_fullscreen_button_toggled(button_pressed):
	if button_pressed==true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN);
		Global.is_fullscreen=true
	if button_pressed==false:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);
		Global.is_fullscreen=false
