extends Node3D

@export var default_voice_pitch:float=2.5
@export var default_phrase:String="Hello!"
@export var default_color:Color=Color.WHITE
@onready var voice=$CharacterVoice
@onready var textbox=$"TextboxMarker/3d_textbox"
signal player_interacted
# Called when the node enters the scene tree for the first time.
func _ready():
	$"TextboxMarker/3d_textbox".visible=false


func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		body.interaction_targets.append(self)
		body.show_interaction_prompt()


func _on_area_3d_body_exited(body):
	if body.is_in_group("player"):
		if self in body.interaction_targets:
			body.interaction_targets.erase(self)
			textbox.visible=false
			body.hide_interaction_prompt()

func set_textbox_message(message:String, message_color:Color):
	default_phrase=message
	default_color=message_color

func interact()->void:
	#player_interacted.emit()
	#if get_parent()!=null and get_parent().has_signal("conversation_updated"):
		#await get_parent().conversation_updated
		#print("awaited")
	if self.get_parent()!=null and self.get_parent().has_method("update_conversation"):
		player_interacted.emit()
	else: play_message()

func play_message(message:String=default_phrase, message_color:Color=default_color, message_pitch:float=default_voice_pitch):
	textbox.set_label_message(message,message_color)
	voice.play_phrase(message,message_pitch)
	textbox.visible=true
