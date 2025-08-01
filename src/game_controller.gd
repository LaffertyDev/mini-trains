extends Node2D

var rail_grid_controller

func _ready():
	rail_grid_controller = %rail_grid

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var pos = rail_grid_controller.world_to_grid(get_global_mouse_position())
			rail_grid_controller.set_grid_at_pos(pos, Constants.GridType.RAIL_HORIZONTAL)
	
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			var pos = rail_grid_controller.world_to_grid(get_global_mouse_position())
			print(rail_grid_controller.get_tile_at_pos(pos))
	

func get_grid() -> GridController:
	return %rail_grid
