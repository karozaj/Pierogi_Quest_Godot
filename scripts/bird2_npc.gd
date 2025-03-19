extends CharacterBody3D

@onready var base_npc=$npc
@export var default_pitch:float=4.5
@export var default_color:Color=Color.DARK_SEA_GREEN
var rng = RandomNumberGenerator.new()
#signal conversation_updated
var conversation_1=["Hey, have you seen my cat?",
"He must have run off somewhere...",
"I'm really worried about him.",
"If you find him, please let me know!"]
var conversation_2=["Did you find my cat?",
"This is an opossum."]
var conversation_3=["Did you find my cat?",
"You actually found him! Thank you so much!"]
var conversation_index:int=-1
var current_conversation=conversation_1
var quest_completed:bool=false
# Called when the node enters the scene tree for the first time.
func _ready():
	$npc.default_voice_pitch=default_pitch
	base_npc.connect("player_interacted",update_conversation)
	Global.connect("possum_collected",on_possum_collected)
	Global.connect("cat_collected",on_cat_collected)

func _process(_delta):
	var player=get_tree().get_first_node_in_group("player")
	if player!=null and !quest_completed:
		look_at(Vector3(player.global_position.x,self.global_position.y,player.global_position.z))

func on_possum_collected():
	if !Global.is_cat_collected:
		current_conversation=conversation_2
		conversation_index=-1
	
func on_cat_collected():
	current_conversation=conversation_3
	conversation_index=-1
	
func update_conversation():
	conversation_index=(conversation_index+1)%current_conversation.size()
	base_npc.play_message(current_conversation[conversation_index],default_color)
