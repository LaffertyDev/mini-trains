extends Node2D

var rail_grid_controller

var player_resources = {
	"tracks_horizontal": 5,
	"tracks_vertical": 5,
	"tracks_junctions_90": 2,
	"tracks_junctions_x": 2,
	"trains": 1
}

func _ready():
	rail_grid_controller = %rail_grid
	%Hud.sync_gui(player_resources)


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
			
func get_player_data():
	return player_resources
			
func handle_build(build_type: Constants.BuildOptions) -> void:
	match build_type:
		Constants.BuildOptions.TRAIN:
			player_resources.trains -= 1
		Constants.BuildOptions.RAIL_VERTICAL:
			player_resources.tracks_vertical -= 1
		Constants.BuildOptions.RAIL_HORIZONTAL:
			player_resources.tracks_horizontal -= 1
		Constants.BuildOptions.RAIL_JUNCTION_X:
			player_resources.tracks_junctions_x -= 1
		Constants.BuildOptions.RAIL_JUNCTION_90:
			player_resources.tracks_junctions_90 -= 1
	%Hud.sync_gui(player_resources)
	
func handle_recycle(piece: Constants.GridType) -> void:
	match piece:
		Constants.GridType.RAIL_VERTICAL:
			player_resources.tracks_vertical += 1
		Constants.GridType.RAIL_HORIZONTAL:
			player_resources.tracks_horizontal += 1
		Constants.GridType.RAIL_JUNCTION_X:
			player_resources.tracks_junctions_x += 1
		Constants.GridType.RAIL_JUNCTION_90:
			player_resources.tracks_junctions_90 += 1
	%Hud.sync_gui(player_resources)
