extends CharacterBody3D

@onready var base_npc=$npc
@export var default_pitch:float=3.0
@export var default_color:Color=Color.BURLYWOOD
#signal conversation_updated
var conversation_1=["Hey there!",
"I would treat you to some pierogi, but...",
"the wind scattered them all over town!",
"Would you help me find them?"]
var conversation_2=["Thank you so much for...\nWait, what do you mean you ate them all?!",
"Thanks a lot..."]
var conversation_index:int=-1
var current_conversation=conversation_1
var quest_completed:bool=false
# Called when the node enters the scene tree for the first time.
func _ready():
	$npc.default_voice_pitch=default_pitch
	base_npc.connect("player_interacted",update_conversation)
	#update_conversation()
	Global.connect("pierogi_collected",change_conversation)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var player=get_tree().get_first_node_in_group("player")
	if player!=null and !quest_completed:
		look_at(Vector3(player.global_position.x,self.global_position.y,player.global_position.z))

func change_conversation():
	current_conversation=conversation_2
	conversation_index=-1
	$AnimationPlayer.play("idle")
	quest_completed=true
	look_at(Vector3(0,0,0))

func update_conversation():
#	if Global.collected_pierogi==Global.total_pierogi:
#		current_conversation=conversation_2
#	else:
#		current_conversation=conversation_1
	conversation_index=(conversation_index+1)%current_conversation.size()
	base_npc.play_message(current_conversation[conversation_index],default_color)
	#conversation_updated.emit()
