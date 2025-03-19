extends CharacterBody3D

@onready var base_npc=$npc
@export var default_pitch:float=3.5
@export var default_color:Color=Color.GREEN_YELLOW
var rng = RandomNumberGenerator.new()
#signal conversation_updated
var conversation_1=["The longer you hold the jump button,\nthe higher you'll go!",
"If you quickly jump three times, you'll jump higher!",
"Try talking to the others,\nthey might have something for you to do."]
var conversation_index:int=-1
var current_conversation=conversation_1
var finished_conversation:bool=false
# Called when the node enters the scene tree for the first time.
func _ready():
	$npc.default_voice_pitch=default_pitch
	base_npc.connect("player_interacted",update_conversation)

func update_conversation():
	conversation_index=(conversation_index+1)%current_conversation.size()
	base_npc.play_message(current_conversation[conversation_index],default_color)
