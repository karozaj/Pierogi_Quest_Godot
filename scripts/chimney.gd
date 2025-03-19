extends Node3D

@export var which_material:int=0

# Called when the node enters the scene tree for the first time.
func _ready():
	var material
	match which_material:
		0:
			material=preload("res://materials/chimney.tres")
		_:
			material=preload("res://materials/chimney2.tres")
	$chimney.set_surface_override_material(0,material)
