extends Node2D

class_name GridController

var train_scene = preload("res://src/entities/train/train.tscn")
var rail_scene = preload("res://src/entities/gridtile/gridtile.tscn")
var build_menu_scene = preload("res://src/ui/build_menu/build_menu.tscn")
var producer_station_scene = preload("res://src/entities/producer_station/producer_station.tscn")

var SIZE_OF_GRIDS = 16

enum CursorState { None, Hovering, Selected }
var cursor_current_state = CursorState.None
var selected_tile = null

func select_transition_state_to_selected() -> void:
	cursor_current_state = CursorState.Selected
	var build_menu: BuildMenuController = get_parent().get_build_menu()
	build_menu.position = grid_to_world_top_left(selected_tile)
	build_menu.setup_build_options(get_tile_at_pos(selected_tile))
	build_menu.show()
	GlobalAudio.play_sound_click_tile()
	
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
	var build_menu: BuildMenuController = get_parent().get_build_menu()
	build_menu.hide()
	
func remove_grid_tile_at_position(pos: Vector2) -> void:
	var real_grid = get_real_tile_at_pos(pos)
	real_grid.get_parent().call_deferred("remove_child", real_grid)
	real_grid.call_deferred("queue_free")

func _input(_ev):
	if Input.is_key_pressed(KEY_ESCAPE):
		if cursor_current_state == CursorState.Selected:
			select_transition_state_to_none()

func handle_left_click():
	match cursor_current_state:
		CursorState.Hovering:
			# select current selectable tile
			var pos = world_to_grid(get_global_mouse_position())
			var tile_at_position = get_tile_at_pos(pos)
			match tile_at_position:
				Constants.GridType.EMPTY:
					select_transition_state_to_selected()
					pass
				Constants.GridType.RAIL_HORIZONTAL:
					select_transition_state_to_selected()
					pass
				Constants.GridType.RAIL_VERTICAL:
					select_transition_state_to_selected()
					pass
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
	
func handle_right_click():
	if cursor_current_state == CursorState.Selected:
		select_transition_state_to_none()
	
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
				Constants.GridType.RAIL_HORIZONTAL:
					select_transition_state_to_hovering(tile_pos)
				Constants.GridType.RAIL_VERTICAL:
					select_transition_state_to_hovering(tile_pos)
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
				Constants.GridType.RAIL_HORIZONTAL:
					select_transition_state_to_hovering(tile_pos)
				Constants.GridType.RAIL_VERTICAL:
					select_transition_state_to_hovering(tile_pos)
				Constants.GridType.RAIL_JUNCTION_X:
					select_transition_state_to_hovering(tile_pos)
				Constants.GridType.RAIL_JUNCTION_90:
					select_transition_state_to_hovering(tile_pos)
				_:
					select_transition_state_to_none()
		CursorState.Selected:
			pass

func set_grid_at_pos(grid_pos: Vector2, grid_type: Constants.GridType, junction_type: Constants.JunctionType) -> void:
	var rail = rail_scene.instantiate()
	rail.position = grid_to_world_top_left(grid_pos)
	rail.grid_type = grid_type
	rail.junction_type = junction_type
	add_child(rail)
	
func setup_producer_at_pos(grid_pos: Vector2) -> void:
	var producer = producer_station_scene.instantiate()
	producer.position = grid_to_world_top_left(grid_pos)
	get_parent().add_child(producer)
	
func spawn_train_at_position(grid_pos: Vector2) -> void:
	var train = train_scene.instantiate()
	train.position = grid_to_world_top_left(grid_pos)
	get_parent().add_child(train)
	
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

func _on_build_menu_option_was_built(option: Constants.BuildOptions) -> void:
	match option:
		Constants.BuildOptions.RECYCLE:
			PlayerData.handle_recycle(get_tile_at_pos(selected_tile))
			remove_grid_tile_at_position(selected_tile)
			GlobalAudio.play_sound_recycle_tile()
		Constants.BuildOptions.TRAIN:
			spawn_train_at_position(selected_tile)
			GlobalAudio.play_sound_place_tile() #TODO
		Constants.BuildOptions.RAIL_VERTICAL:
			set_grid_at_pos(selected_tile, Constants.GridType.RAIL_VERTICAL, Constants.JunctionType.EAST_SOUTH)
			PlayerData.handle_build(option)
			GlobalAudio.play_sound_place_tile()
		Constants.BuildOptions.RAIL_HORIZONTAL:
			set_grid_at_pos(selected_tile, Constants.GridType.RAIL_HORIZONTAL, Constants.JunctionType.EAST_SOUTH)
			PlayerData.handle_build(option)
			GlobalAudio.play_sound_place_tile()
		Constants.BuildOptions.RAIL_JUNCTION_X:
			set_grid_at_pos(selected_tile, Constants.GridType.RAIL_JUNCTION_X, Constants.JunctionType.VERTICAL)
			PlayerData.handle_build(option)
			GlobalAudio.play_sound_place_tile()
		Constants.BuildOptions.RAIL_JUNCTION_90:
			set_grid_at_pos(selected_tile, Constants.GridType.RAIL_JUNCTION_90, Constants.JunctionType.EAST_SOUTH)
			PlayerData.handle_build(option)
			GlobalAudio.play_sound_place_tile()
	select_transition_state_to_none()
