extends Control

var total:int=0

# Called when the node enters the scene tree for the first time.
func _ready():
	get_total_number()
	update_label(0)

func get_total_number()->void:
	for member in get_tree().get_nodes_in_group("collectibles"):
		total+=1
	Global.total_pierogi=total
		
func update_label(collected:int)->void:
	$Label.text=str(collected)+"/"+str(total)
