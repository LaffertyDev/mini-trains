extends Node2D

class_name GridController

var rail_scene = preload("res://src/entities/gridtile/gridtile.tscn")

var SIZE_OF_GRIDS = 16

enum CursorState { None, Hovering, Selected }
var cursor_current_state = CursorState.None
var selected_tile = null

func select_transition_state_to_selected(tile: Vector2) -> void:
	selected_tile = tile
	cursor_current_state = CursorState.Selected
	
func select_transition_state_to_hovering(tile: Vector2) -> void:
	selected_tile = tile
	cursor_current_state = CursorState.Hovering
	var tile_pos_world_coords = grid_to_world_top_left(tile)
	%highlight_marker.position = tile_pos_world_coords + Vector2(8, 8)
	%highlight_marker.show()
	
func select_transition_state_to_none() -> void:
	selected_tile = null
	cursor_current_state = CursorState.None
	%highlight_marker.hide()

func select_state_transition_to(tile_state_switch_to: CursorState) -> void:
	pass

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var pos = world_to_grid(get_global_mouse_position())
			var tile_at_position = get_tile_at_pos(pos)
			match tile_at_position:
				Constants.GridType.EMPTY:
					pass
					#cursor_current_state = CursorState.Selected
					#set_grid_at_pos(pos, Constants.GridType.RAIL_HORIZONTAL)
				Constants.GridType.BLOCKED_INVISIBLE:
					# do nothing
					pass
				Constants.GridType.RAIL_JUNCTION_X:
					if cursor_current_state == CursorState.Hovering:
						var tile = get_real_tile_at_pos(pos)
						tile.rotate_tile()
				Constants.GridType.RAIL_JUNCTION_90:
					if cursor_current_state == CursorState.Hovering:
						var tile = get_real_tile_at_pos(pos)
						tile.rotate_tile()
	
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			var pos = world_to_grid(get_global_mouse_position())
			print(get_tile_at_pos(pos))
	
func _process(_delta: float) -> void:
	var tile_pos = world_to_grid(get_global_mouse_position())
	var tile = get_tile_at_pos(tile_pos)
	match cursor_current_state:
		CursorState.None:
			match tile:
				Constants.GridType.EMPTY:
					select_transition_state_to_hovering(tile_pos)
				Constants.GridType.BLOCKED_INVISIBLE:
					select_transition_state_to_none()
				Constants.GridType.RAIL_JUNCTION_X:
					select_transition_state_to_hovering(tile_pos)
				Constants.GridType.RAIL_JUNCTION_90:
					select_transition_state_to_hovering(tile_pos)
		CursorState.Hovering:
			match tile:
				Constants.GridType.EMPTY:
					select_transition_state_to_hovering(tile_pos)
				Constants.GridType.BLOCKED_INVISIBLE:
					select_transition_state_to_none()
					# do nothing
				Constants.GridType.RAIL_JUNCTION_X:
					select_transition_state_to_hovering(tile_pos)
				Constants.GridType.RAIL_JUNCTION_90:
					select_transition_state_to_hovering(tile_pos)
				_:
					select_transition_state_to_none()
		CursorState.Selected:
			pass

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
