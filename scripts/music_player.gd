extends AudioStreamPlayer

var default_volume:float=.5
#var default_volume:float=0
var music:AudioStream

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode=Node.PROCESS_MODE_ALWAYS
	add_to_group("music_players")
	music=preload("res://assets/sound/music/Soporific.ogg")
	stream=music
	update_music_volume(Global.music_volume)
	play()

func update_music_volume(volume_modifier:float):
	volume_db=linear_to_db(volume_modifier*default_volume)
