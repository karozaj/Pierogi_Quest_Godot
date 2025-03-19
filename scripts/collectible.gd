extends Node3D

@export var default_pitch=3.0
@export var default_volume=0.07
@onready var audio_player=$AudioStreamPlayer3D
var rng = RandomNumberGenerator.new()
var is_collected:bool=false
@export var spinning_speed:float=60
@export var floating_speed=0.15

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("sound_players")
	add_to_group("collectibles")
	update_sound_effect_volume(Global.sound_effects_volume)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Cylinder.rotate_y(delta*deg_to_rad(spinning_speed))
	$Cylinder.position.y+=floating_speed*delta
	if $Cylinder.position.y<0.75:
		floating_speed=-floating_speed
	elif $Cylinder.position.y>1.0:
		floating_speed=-floating_speed
		
func _on_area_3d_body_entered(body):
	if body.is_in_group("player") and is_collected==false:
		is_collected=true
		audio_player.pitch_scale=default_pitch+rng.randf_range(-0.15,0.15)
		audio_player.play()
		if body.has_method("collect_item"):
			body.collect_item()
		await audio_player.finished
		queue_free()

func update_sound_effect_volume(volume_modifier):
	$AudioStreamPlayer3D.volume_db=linear_to_db(volume_modifier*default_volume)
