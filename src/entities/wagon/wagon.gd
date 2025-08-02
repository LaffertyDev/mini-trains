extends Node2D
class_name Wagon

var following

func _ready():
	var train = get_tree().get_nodes_in_group("trains")[0]
	following = train

func _process(delta: float) -> void:
	self.position = following.position - (following.movement_direction * 20)
	
