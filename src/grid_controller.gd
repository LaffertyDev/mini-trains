extends Node

class_name GridController

var rail_scene = preload("res://src/entities/gridtile/gridtile.tscn")

var SIZE_OF_GRIDS = 16

func set_grid_at_pos(grid_pos: Vector2, grid_type: Constants.GridType) -> void:
	var rail = rail_scene.instantiate()
	rail.position = grid_to_world_top_left(grid_pos)
	rail.grid_position = grid_pos
	rail.grid_type = grid_type
	add_child(rail)
	
func get_tile_at_pos(grid_pos: Vector2) -> Constants.GridType:
	var gridtiles = get_tree().get_nodes_in_group("grid_tiles")
	for gt in gridtiles:
		var grid_position = world_to_grid(gt.position)
		if grid_position == grid_pos:
			return gt.grid_type
	return Constants.GridType.EMPTY
	
func world_to_grid(world_pos: Vector2) -> Vector2:
	var x = floor(world_pos.x / SIZE_OF_GRIDS)
	var y = floor(world_pos.y / SIZE_OF_GRIDS)
	return Vector2(x, y)
	
func grid_to_world_top_left(grid_pos: Vector2) -> Vector2:
	var x = floor(grid_pos.x * SIZE_OF_GRIDS)
	var y = floor(grid_pos.y * SIZE_OF_GRIDS)
	return Vector2(x, y)

func destroy_rail(grid_pos: Vector2) -> void:
	pass
