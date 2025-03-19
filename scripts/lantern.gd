extends Node3D

@export var default_pitch=1
@export var default_volume=0.5
@onready var audio_player=$AudioStreamPlayer3D
var rng = RandomNumberGenerator.new()

@export var which_material:int=0
@onready var anim_player=$AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	var material
	match which_material:
		0:
			material=preload("res://materials/lantern1.tres")
		_:
			material=preload("res://materials/lantern2.tres")
	$lantern2.set_surface_override_material(0,material)
	add_to_group("sound_players")
	update_sound_effect_volume(Global.sound_effects_volume)

func _on_area_3d_body_entered(body):
	if body.is_in_group("player") and not anim_player.is_playing():
		anim_player.play("sway")
		audio_player.pitch_scale=default_pitch+rng.randf_range(-0.15,0.15)
		audio_player.play()

func update_sound_effect_volume(volume_modifier):
	$AudioStreamPlayer3D.volume_db=linear_to_db(volume_modifier*default_volume)
