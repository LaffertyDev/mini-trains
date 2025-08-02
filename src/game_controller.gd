extends Node2D

var rail_grid_controller

var player_resources = {
	"tracks_horizontal": 0,
	"tracks_vertical": 0,
	"tracks_junctions_90": 0,
	"tracks_junctions_x": 0,
	"trains": 0
}

func _ready():
	rail_grid_controller = %rail_grid

func get_grid() -> GridController:
	return %rail_grid
