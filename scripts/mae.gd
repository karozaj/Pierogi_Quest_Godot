extends CharacterBody3D
#const SPEED = 5.0
#const WALK_SPEED=2.5
#const JUMP_VELOCITY = 6.0
#constants
const LERP_VAL=.15
const JUMP_HEIGHT=2.0

#camera control
@onready var spring_arm_pivot=$SpringArmPivot
@onready var spring_arm=$SpringArmPivot/SpringArm3D

#movement variables
@export_category("Movement Parameters")
@export var jump_peak_time: float =.5
@export var jump_fall_time: float =.5
@export var jump_height: float = 2.0
@export var jump_distance: float=4.0
var gravity:float# = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed:float
var max_speed:float
var jump_velocity:float
var jump_available:bool=true
var jump_buffer:bool=false
var is_jumping:bool=false
var triple_jump_condition=[false,false]
@onready var coyote_timer=$CoyoteTimer
@onready var jump_buffer_timer=$JumpBufferTimer
@onready var triple_jump_timer=$TripleJumpTimer
@onready var movement_lerp_val=LERP_VAL

#animation variables
var run_val=0
var jump_val=0
var starting_rotation=0
@onready var armature=$Rig
@onready var anim_tree=$AnimationTree
#audio jump variables
@export var default_pitch=1.35
@export var default_volume=0.00001
@onready var audio_player=$AudioStreamPlayer3D
var rng = RandomNumberGenerator.new()
var jump_sounds
var land_sound
var was_on_floor:bool=true
#audio walk variables
@export var default_pitch_run=1.35
@export var default_volume_run=0.00001
@onready var audio_player_run=$RunAudioPlayer
var which_walk_sfx:int=0
var run_sounds

#game variables
var collected_items:int=0
var interaction_targets=[]
var active_interaction_target=null

func _ready():
	self.add_to_group("player")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	calculate_movement_parameters()
	speed=max_speed
	starting_rotation=rotation.y
	#prepare sound
	self.add_to_group("sound_players")
	update_sound_effect_volume(Global.sound_effects_volume)
	$Menus/interaction_prompt.visible=false
	jump_sounds=[preload("res://assets/sound/ha1.ogg"), preload("res://assets/sound/ha2.ogg"),preload("res://assets/sound/ha3.ogg")]
	land_sound=preload("res://assets/sound/jump_land.ogg")
	run_sounds=[preload("res://assets/sound/footstep1.ogg"), preload("res://assets/sound/footstep2.ogg"),preload("res://assets/sound/footstep3.ogg")]
	
func _physics_process(delta):
	# Get the input direction
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction=direction.rotated(Vector3.UP, spring_arm_pivot.rotation.y)
	
	# Add the gravity
	if not is_on_floor():
		movement_lerp_val=0.3*LERP_VAL
		if jump_available:
			if coyote_timer.is_stopped():
				coyote_timer.start()
		if velocity.y>=0 and Input.is_action_pressed("jump"):
			velocity.y -= gravity * delta
		elif velocity.y>0:
			velocity.y -= 2.5*gravity * delta
		else:
			velocity.y-= 1.5*gravity * delta
	else:
		movement_lerp_val=LERP_VAL
		jump_available=true
		coyote_timer.stop()
		if triple_jump_condition[0]!=false and triple_jump_timer.is_stopped():
			triple_jump_timer.start()
		if jump_buffer:
			jump()

	#handle movement
	if direction:
		velocity.x = lerp(velocity.x,direction.x * speed,movement_lerp_val)
		velocity.z = lerp(velocity.z,direction.z * speed,movement_lerp_val)
		armature.rotation.y=lerp_angle(armature.rotation.y,atan2(-velocity.x,-velocity.z )-starting_rotation, LERP_VAL)
	else :
		velocity.x = lerp(velocity.x,0.0,movement_lerp_val)
		velocity.z = lerp(velocity.z,0.0,movement_lerp_val)

	#handle jump
	if Input.is_action_just_pressed("jump"):
		if jump_available:
			jump()
		else:
			jump_buffer=true
			jump_buffer_timer.start()
	
	#play landing sound
	if is_on_floor()==true and was_on_floor==false:
		play_landing_sound()
	was_on_floor=is_on_floor()
	
	update_animation(delta)
	move_and_slide()
	
func _process(_delta):
	if Input.is_action_just_pressed("zoom_camera") and spring_arm.spring_length>=1.0:
		spring_arm.spring_length-=0.2
	elif Input.is_action_just_pressed("unzoom_camera") and spring_arm.spring_length<=10.0:
		spring_arm.spring_length+=0.2
	if Input.is_action_just_pressed("exit"):
		var pause_menu=preload("res://scenes/ui/pause_menu.tscn").instantiate()
		$Menus.add_child(pause_menu)
	if Input.is_action_just_pressed("switch_walk") and is_on_floor():
		if speed==max_speed:
			speed=max_speed/2.5
		else:
			speed=max_speed
	if Input.is_action_just_pressed("interact") and !interaction_targets.is_empty():
		active_interaction_target=find_active_interaction_target()
		active_interaction_target.interact()
	#gamepad camera control
	var camera_rotation_vector = Input.get_vector("camera_up_gamepad", "camera_down_gamepad","camera_right_gamepad", "camera_left_gamepad")
	if camera_rotation_vector:
		spring_arm_pivot.rotate_y(deg_to_rad(camera_rotation_vector.y*2))
		spring_arm.rotate_x(deg_to_rad(camera_rotation_vector.x*2))
		spring_arm.rotation.x=clamp(spring_arm.rotation.x,-PI/4,PI/4)
	if Input.is_action_pressed("zoom_gamepad") and spring_arm.spring_length>=1.0:
		spring_arm.spring_length-=0.05
	elif Input.is_action_pressed("unzoom_gamepad") and spring_arm.spring_length<=10.0:
		spring_arm.spring_length+=0.05
		
func _unhandled_input(event):
	#look around using mouse
	if event is InputEventMouseMotion:
		spring_arm_pivot.rotate_y(-event.relative.x*0.005)
		spring_arm.rotate_x(-event.relative.y*0.005)
		spring_arm.rotation.x=clamp(spring_arm.rotation.x,-PI/4,PI/4)
		
func jump()->void:
	triple_jump_timer.stop()
	if triple_jump_condition==[true,true]:
		jump_height=1.25*JUMP_HEIGHT
		calculate_movement_parameters()
		velocity.y=jump_velocity
		jump_height=JUMP_HEIGHT
		calculate_movement_parameters()
		#print("triple jump")
		#play jump audio
		play_jump_sound(true)
	else:
		velocity.y=jump_velocity
		#play jump audio
		play_jump_sound(false)
	
	if triple_jump_condition[0]==false: triple_jump_condition[0]=true; #print(triple_jump_condition)
	elif triple_jump_condition[1]==false: triple_jump_condition[1]=true;# print(triple_jump_condition)
	elif triple_jump_condition==[true,true]: triple_jump_condition=[false,false]
	jump_available=false

func calculate_movement_parameters()->void:
	gravity=(2*jump_height)/pow(jump_peak_time,2)
	jump_velocity=gravity*jump_peak_time
	max_speed=jump_distance/(jump_peak_time+jump_fall_time)
	#print("grav: ",gravity)
	#print("jmp_vel: ",jump_velocity)
	#print("spd: ",speed)

func update_animation(delta)->void:
	if is_on_floor():
		jump_val=0
		anim_tree.set("parameters/Jump/blend_amount", jump_val)
		run_val=Vector3(velocity.x,0,velocity.z).length()/max_speed
		anim_tree.set("parameters/Run/blend_amount",run_val)
	else:
		anim_tree.set("parameters/Run/blend_amount",lerpf(run_val,0.0,25*delta))
		jump_val=lerpf(jump_val,1.0,25*delta)
		anim_tree.set("parameters/Jump/blend_amount", jump_val)

func _on_coyote_timer_timeout():
	jump_available=false

func _on_jump_buffer_timer_timeout():
	jump_buffer=false

func _on_triple_jump_timer_timeout():
	#print("tj timeout")
	triple_jump_condition=[false,false]

func update_sound_effect_volume(volume_modifier:float)->void:
	$AudioStreamPlayer3D.volume_db=linear_to_db(volume_modifier*default_volume)
	$RunAudioPlayer.volume_db=linear_to_db(volume_modifier*default_volume_run)

func play_walking_sound()->void:
	if Vector2(velocity.x,velocity.z).length()>=max_speed/3 and is_on_floor():
		audio_player_run.stream=run_sounds[which_walk_sfx]
		audio_player_run.pitch_scale=default_pitch+rng.randf_range(-0.1,0.1)
		audio_player_run.play()
		which_walk_sfx=(which_walk_sfx+1)%3

func play_landing_sound()->void:
	audio_player_run.pitch_scale=default_pitch_run+rng.randf_range(-0.1,0.1)
	audio_player_run.stream=land_sound
	audio_player_run.play()

func play_jump_sound(is_triple_jump:bool)->void:
	if is_triple_jump==false:
		audio_player.stream=jump_sounds[rng.randi_range(0,1)]
		audio_player.pitch_scale=default_pitch+rng.randf_range(-0.1,0.1)
	else:
		audio_player.stream=jump_sounds[2]
		audio_player.pitch_scale=default_pitch
	audio_player.play()

func collect_item()->void:
	collected_items+=1
	Global.collected_pierogi=collected_items
	$Menus/CollectibleCounter.update_label(collected_items)

func find_active_interaction_target():
	var closest_target=interaction_targets[0]
	var distance=self.global_position.distance_to(interaction_targets[0].global_position)
	for i in range(1,interaction_targets.size()):
		if distance>self.global_position.distance_to(interaction_targets[i].global_position):
			distance=self.global_position.distance_to(interaction_targets[i].global_position)
			closest_target=interaction_targets[i]
	return closest_target

func show_interaction_prompt():
	$Menus/interaction_prompt.visible=true
	
func hide_interaction_prompt():
	$Menus/interaction_prompt.visible=false
