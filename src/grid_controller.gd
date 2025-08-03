extends Node2D
class_name GridController

var train_scene = preload("res://src/entities/train/train.tscn")
var rail_scene = preload("res://src/entities/gridtile/gridtile.tscn")
var build_menu_scene = preload("res://src/ui/build_menu/build_menu.tscn")
var producer_station_scene = preload("res://src/entities/producer_station/producer_station.tscn")

func remove_grid_tile_at_position(pos: Vector2) -> void:
	var real_grid = get_real_tile_at_pos(pos)
	real_grid.get_parent().call_deferred("remove_child", real_grid)
	real_grid.call_deferred("queue_free")

func _process(_delta: float) -> void:
	var tile_pos = world_to_grid(get_global_mouse_position())
	var tile = get_tile_at_pos(tile_pos)
	var gui_control_mode: Constants.GuiControlMode = get_tree().current_scene.get_gui().get_hud_control_mode()
	match gui_control_mode:
		Constants.GuiControlMode.NONE:
			var ghost = get_parent().get_node("ghost")
			ghost.hide()
			pass
		Constants.GuiControlMode.TRACK:
			if tile == Constants.GridType.EMPTY:
				# show a ghost tile
				var ghost = get_parent().get_node("ghost")
				ghost.position = grid_to_world_top_left(world_to_grid(get_global_mouse_position())) + Vector2(8, 8)
				ghost.show()
			else:
				var ghost = get_parent().get_node("ghost")
				ghost.position = grid_to_world_top_left(world_to_grid(get_global_mouse_position())) + Vector2(8, 8)
				ghost.hide()
				
			if Input.is_action_pressed("primary_action"):
				if tile == Constants.GridType.EMPTY and PlayerData.current_tracks > 0:
					set_grid_at_pos(tile_pos, Constants.GridType.TRACK)
					PlayerData.handle_build()
					GlobalAudio.play_sound_place_tile()
					get_tree().call_group("grid_tiles", "update_permitted_rotations")
			elif Input.is_action_pressed("secondary_action"):
				if tile == Constants.GridType.TRACK:
					PlayerData.handle_recycle()
					remove_grid_tile_at_position(tile_pos)
					get_tree().call_group("grid_tiles", "update_permitted_rotations")
					GlobalAudio.play_sound_recycle_tile()

func set_grid_at_pos(grid_pos: Vector2, grid_type: Constants.GridType) -> void:
	var rail = rail_scene.instantiate()
	rail.position = grid_to_world_top_left(grid_pos)
	rail.grid_type = grid_type
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
	var x = floor(world_pos.x / Constants.GRID_TILE_SIZE_PIXELS)
	var y = floor(world_pos.y / Constants.GRID_TILE_SIZE_PIXELS)
	return Vector2(x, y)
	
func grid_to_world_top_left(grid_pos: Vector2) -> Vector2:
	var x = floor(grid_pos.x * Constants.GRID_TILE_SIZE_PIXELS)
	var y = floor(grid_pos.y * Constants.GRID_TILE_SIZE_PIXELS)
	return Vector2(x, y)
