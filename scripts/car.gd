extends Node3D

@onready var anim_player=$AnimationPlayer
@export var which_material=0

@export var default_pitch=1.25
@export var default_volume=0.75
@onready var audio_player_front=$AudioStreamPlayer3DFront
@onready var audio_player_back=$AudioStreamPlayer3DBack
var rng = RandomNumberGenerator.new()

func _ready():
	var material
	match which_material:
		0:
			material=preload("res://materials/car_green.tres")
		1:
			material=preload("res://materials/car_orange.tres")
		2:
			material=preload("res://materials/car_blue.tres")
		_:
			material=preload("res://materials/rusty_car.tres")
	$Armature/Skeleton3D/car.set_surface_override_material(0,material)
	add_to_group("sound_players")
	update_sound_effect_volume(Global.sound_effects_volume)

func _on_front_suspension_area_body_entered(body):
	if body.is_in_group("player"):
		anim_player.play("suspension_front")
		audio_player_front.pitch_scale=default_pitch+rng.randf_range(-0.1,0.1)
		audio_player_front.play()
	
func _on_back_suspension_area_body_entered(body):
	if body.is_in_group("player"):
		audio_player_back.pitch_scale=default_pitch+rng.randf_range(-0.1,0.1)
		audio_player_back.play()
		anim_player.play("suspension_back")

func update_sound_effect_volume(volume_modifier):
	$AudioStreamPlayer3DFront.volume_db=linear_to_db(volume_modifier*default_volume)
	$AudioStreamPlayer3DBack.volume_db=linear_to_db(volume_modifier*default_volume)
