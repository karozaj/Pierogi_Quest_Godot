extends CharacterBody3D

@onready var base_npc=$npc
@export var default_pitch:float=2.0
@export var default_color:Color=Color.DARK_KHAKI
var rng = RandomNumberGenerator.new()
#signal conversation_updated
var conversation_1=["Dang, the road's blocked again...",
"The storm brought down some trees...",
"I hope they can get this fixed soon.",
"I sure hope they reopen the road soon..."]
var conversation_index:int=-1
var current_conversation=conversation_1
# Called when the node enters the scene tree for the first time.
func _ready():
	$npc.default_voice_pitch=default_pitch
	base_npc.connect("player_interacted",update_conversation)
	
func update_conversation():
	conversation_index=rng.randi_range(0,current_conversation.size()-1)
	#conversation_index=(conversation_index+1)%current_conversation.size()
	base_npc.play_message(current_conversation[conversation_index],default_color)
