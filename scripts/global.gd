extends Node

var sound_effects_volume:float=0.50
var music_volume:float=0.50
var is_fullscreen:bool=false

func update_sound_effect_volume():
	for member in get_tree().get_nodes_in_group("sound_players"):
		if member.has_method("update_sound_effect_volume"):
			member.update_sound_effect_volume(sound_effects_volume)
			
func update_music_volume():
	for member in get_tree().get_nodes_in_group("music_players"):
		if member.has_method("update_music_volume"):
			member.update_music_volume(music_volume)

#PIEROGI QUEST
signal pierogi_collected
var total_pierogi:int=0
var collected_pierogi:int=0:
	get:
		return collected_pierogi
	set(value):
		collected_pierogi=value
		if collected_pierogi==total_pierogi:
			pierogi_collected.emit()

#CAR BATTERY QUEST
signal battery_collected
var is_battery_collected:bool=false:
	get:
		return is_battery_collected
	set(value):
		is_battery_collected=value
		if value==true:
			battery_collected.emit()

#CAT QUEST
signal possum_collected
signal cat_collected
var is_possum_collected:bool=false:
	get:
		return is_possum_collected
	set(value):
		is_possum_collected=value
		if value==true:
			possum_collected.emit()
var is_cat_collected:bool=false:
	get:
		return is_cat_collected
	set(value):
		is_cat_collected=value
		if value==true:
			cat_collected.emit()
