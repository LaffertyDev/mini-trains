extends Node2D

var rail_grid_controller

func _ready():
	rail_grid_controller = %rail_grid

func get_grid() -> GridController:
	return %rail_grid
