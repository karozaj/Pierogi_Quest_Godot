extends AudioStreamPlayer

@export var default_pitch=2.0
@export var default_volume=8.0
@onready var audio_player=$"."
var rng = RandomNumberGenerator.new()
const sounds = {
	'a': preload("res://assets/sound/alphabet/a.ogg"),
	'b': preload("res://assets/sound/alphabet/b.ogg"),
	'c': preload("res://assets/sound/alphabet/c.ogg"),
	'd': preload("res://assets/sound/alphabet/d.ogg"),
	'e': preload("res://assets/sound/alphabet/e.ogg"),
	'f': preload("res://assets/sound/alphabet/f.ogg"),
	'g': preload("res://assets/sound/alphabet/g.ogg"),
	'h': preload("res://assets/sound/alphabet/h.ogg"),
	'i': preload("res://assets/sound/alphabet/i.ogg"),
	'j': preload("res://assets/sound/alphabet/j.ogg"),
	'k': preload("res://assets/sound/alphabet/k.ogg"),
	'l': preload("res://assets/sound/alphabet/l.ogg"),
	'm': preload("res://assets/sound/alphabet/m.ogg"),
	'n': preload("res://assets/sound/alphabet/n.ogg"),
	'o': preload("res://assets/sound/alphabet/o.ogg"),
	'p': preload("res://assets/sound/alphabet/p.ogg"),
	'q': preload("res://assets/sound/alphabet/q.ogg"),
	'r': preload("res://assets/sound/alphabet/r.ogg"),
	's': preload("res://assets/sound/alphabet/s.ogg"),
	't': preload("res://assets/sound/alphabet/t.ogg"),
	'u': preload("res://assets/sound/alphabet/u.ogg"),
	'v': preload("res://assets/sound/alphabet/w.ogg"),
	'w': preload("res://assets/sound/alphabet/w.ogg"),
	'x': preload("res://assets/sound/alphabet/x.ogg"),
	'y': preload("res://assets/sound/alphabet/y.ogg"),
	'z': preload("res://assets/sound/alphabet/z.ogg"),
	' ': preload("res://assets/sound/alphabet/blank.ogg"),
	'.': preload("res://assets/sound/alphabet/blank_long.ogg")
}

var current_phrase=[]
var interrupted:bool=false

func _ready():
	add_to_group("sound_players")
	update_sound_effect_volume(Global.sound_effects_volume)
	pitch_scale=default_pitch

func update_sound_effect_volume(volume_modifier)->void:
	$".".volume_db=linear_to_db(volume_modifier*default_volume)

func play_phrase(s:String, current_pitch:float)->void:
	interrupted=false
	default_pitch=current_pitch
	parse_phrase(s)
	while len(current_phrase)>0:
		stream=current_phrase.pop_front()
		pitch_scale=default_pitch+rng.randf_range(-.15,.15)
		play()
		await $".".finished
		if interrupted:
			current_phrase=[]
			return

func parse_phrase(s:String)->void:
	for c in s:
		if c.to_lower() in sounds:
			current_phrase.append(sounds[c.to_lower()])
		else:
			current_phrase.append(sounds[' '])

func interrupt()->void:
	interrupted=true
