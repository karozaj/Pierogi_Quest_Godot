extends Node3D

var animation_has_played:bool=false
@export var default_pitch=2.5
@export var default_volume=0.05
@onready var audio_player=$AudioStreamPlayer3D
var rng = RandomNumberGenerator.new()

func _ready():
	add_to_group("sound_players")
	update_sound_effect_volume(Global.sound_effects_volume)

func _on_area_3d_body_entered(body):
	if body.is_in_group("player") and not animation_has_played:
		$AnimationPlayer.play("bend")
		audio_player.pitch_scale=default_pitch+rng.randf_range(-0.15,0.15)
		audio_player.play()
		animation_has_played=true

func update_sound_effect_volume(volume_modifier):
	$AudioStreamPlayer3D.volume_db=linear_to_db(volume_modifier*default_volume)
