extends Node3D

@export var default_pitch=1
@export var default_volume=0.005
@onready var audio_player=$AudioStreamPlayer3D

func _ready():
	add_to_group("sound_players")
	update_sound_effect_volume(Global.sound_effects_volume)
	audio_player.pitch_scale=default_pitch

func update_sound_effect_volume(volume_modifier):
	$AudioStreamPlayer3D.volume_db=linear_to_db(volume_modifier*default_volume)
