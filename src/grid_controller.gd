extends Node2D

class_name GridController

var rail_scene = preload("res://src/entities/gridtile/gridtile.tscn")

var SIZE_OF_GRIDS = 16

enum TILE_STATE { None, Hovering, Selected }
var current_state = TILE_STATE.None

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var pos = world_to_grid(get_global_mouse_position())
			var tile_at_position = get_real_tile_at_pos(pos)
			if tile_at_position:
				match tile_at_position.grid_type:
					Constants.GridType.RAIL_JUNCTION:
						tile_at_position.rotate_tile()
			else:
				set_grid_at_pos(pos, Constants.GridType.RAIL_HORIZONTAL)
	
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			var pos = world_to_grid(get_global_mouse_position())
			print(get_tile_at_pos(pos))
	
func _process(_delta: float) -> void:
	var tile_pos = world_to_grid(get_global_mouse_position())
	var tile_pos_world_coords = grid_to_world_top_left(tile_pos)
	%highlight_marker.position = tile_pos_world_coords + Vector2(8, 8)

func set_grid_at_pos(grid_pos: Vector2, grid_type: Constants.GridType) -> void:
	var rail = rail_scene.instantiate()
	rail.position = grid_to_world_top_left(grid_pos)
	rail.grid_type = grid_type
	add_child(rail)
	
func get_tile_at_pos(grid_pos: Vector2) -> Constants.GridType:
	var gridtiles = get_tree().get_nodes_in_group("grid_tiles")
	for gt in gridtiles:
		var grid_position = world_to_grid(gt.global_position)
		if grid_position == grid_pos:
			return gt.grid_type
	return Constants.GridType.EMPTY

func get_real_tile_at_pos(grid_pos: Vector2) -> GridTile:
	var gridtiles = get_tree().get_nodes_in_group("grid_tiles")
	for gt in gridtiles:
		var grid_position = world_to_grid(gt.global_position)
		if grid_position == grid_pos:
			return gt
	return null
	
func world_to_grid(world_pos: Vector2) -> Vector2:
	var x = floor(world_pos.x / SIZE_OF_GRIDS)
	var y = floor(world_pos.y / SIZE_OF_GRIDS)
	return Vector2(x, y)
	
func grid_to_world_top_left(grid_pos: Vector2) -> Vector2:
	var x = floor(grid_pos.x * SIZE_OF_GRIDS)
	var y = floor(grid_pos.y * SIZE_OF_GRIDS)
	return Vector2(x, y)
