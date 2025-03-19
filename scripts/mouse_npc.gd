extends CharacterBody3D

@onready var base_npc=$npc
@export var default_pitch:float=2.75
@export var default_color:Color=Color.DARK_ORANGE
var rng = RandomNumberGenerator.new()
#signal conversation_updated
var conversation_1=["Oh crap, the battery's busted...",
"Hey, you don't happen to have a spare\ncar battery I could borrow, do you?",
"UGHHHHHHHHHHHHHHHHHHH"]
var conversation_2=["What? You found a battery?",
"What is this? Where did you find this?",
"I'm not touching that with a ten-foot pole!\nIt's clearly broken and dangerous!",
"Get away from me!"]
var conversation_index:int=-1
var current_conversation=conversation_1
var finished_conversation:bool=false
# Called when the node enters the scene tree for the first time.
func _ready():
	$npc.default_voice_pitch=default_pitch
	base_npc.connect("player_interacted",update_conversation)
	Global.connect("battery_collected",change_conversation)
	
func change_conversation():
	current_conversation=conversation_2
	conversation_index=-1

func update_conversation():
	if current_conversation==conversation_2 and conversation_index==3:
		finished_conversation=true
	if !finished_conversation:
		conversation_index=(conversation_index+1)%current_conversation.size()
	base_npc.play_message(current_conversation[conversation_index],default_color)
