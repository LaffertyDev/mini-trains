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

func get_build_menu() -> BuildMenuController:
	return %BuildMenu


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			rail_grid_controller.handle_left_click()
			
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			rail_grid_controller.handle_right_click()
