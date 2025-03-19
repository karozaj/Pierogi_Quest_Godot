extends Node3D

@export var which_material:int=0

# Called when the node enters the scene tree for the first time.
func _ready():
	var material
	match which_material:
		0:
			material=preload("res://materials/house1.tres")
		1:
			material=preload("res://materials/house1_2.tres")
		_:
			material=preload("res://materials/house1_3.tres")
	$Cube.set_surface_override_material(0,material)
