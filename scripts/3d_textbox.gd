extends Control

## The waypoint's text.
@export var text := "Waypoint":
	set(value):
		text = value
		# The label's text can only be set once the node is ready.
		if is_inside_tree():
			label.text = value


@onready var camera := get_viewport().get_camera_3d()
@onready var parent := get_parent()
@onready var label: Label = $Label
#@onready var marker: TextureRect = $Marker

func _ready() -> void:
	self.text = text
	assert(parent is Node3D, "The waypoint's parent node must inherit from Node3D.")


func _process(_delta: float) -> void:
	if not camera.current:
		# If the camera we have isn't the current one, get the current camera.
		camera = get_viewport().get_camera_3d()

	var parent_position: Vector3 = parent.global_transform.origin
	var unprojected_position := camera.unproject_position(parent_position)
	position = unprojected_position
	
func set_label_message(message:String, message_color:Color)->void:
	label.text=message
	label.set("theme_override_colors/font_color",message_color)
	
	#var camera_transform := camera.global_transform
	#var camera_position := camera_transform.origin
#	# Fade the waypoint when the camera gets close.
#	var distance := camera_position.distance_to(parent_position)
#	modulate.a = clamp(remap(distance, 0, 2, 0, 1), 0, 1 )
	# `get_size_override()` will return a valid size only if the stretch mode is `2d`.
	# Otherwise, the viewport size is used directly.

