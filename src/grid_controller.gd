extends Node2D
class_name GridController

var train_scene = preload("res://src/entities/train/train.tscn")
var rail_scene = preload("res://src/entities/gridtile/gridtile.tscn")
var producer_station_scene = preload("res://src/entities/producer_station/producer_station.tscn")

var ghost_track
var ghost_train
var rotate_icon

func _ready():
	ghost_track = %ghost_track
	ghost_train = %ghost_train
	rotate_icon = %rotate_icon

func remove_grid_tile_at_position(pos: Vector2) -> void:
	var real_grid = get_real_tile_at_pos(pos)
	if real_grid:
		real_grid.get_parent().call_deferred("remove_child", real_grid)
		real_grid.call_deferred("queue_free")

func _process(_delta: float) -> void:
	var tile_pos = world_to_grid(get_global_mouse_position())
	var tile = get_tile_at_pos(tile_pos)
	var real_tile = get_real_tile_at_pos(tile_pos)
	match tile:
		Constants.GridType.EMPTY:
			if PlayerData.current_tracks > 0:
				# show a ghost tile
				ghost_track.position = grid_to_world_top_left(world_to_grid(get_global_mouse_position())) + Vector2(8, 8)
				ghost_track.show()
			else:
				ghost_track.hide()
			ghost_train.hide()
			rotate_icon.hide()
		Constants.GridType.TRACK:
			if real_tile.permitted_rotations.size() == 1:
				if PlayerData.current_trains > 0:
					# show a ghost tile
					ghost_train.position = grid_to_world_top_left(world_to_grid(get_global_mouse_position())) + Vector2(8, 8)
					ghost_train.show()
				else:
					ghost_train.hide()
				ghost_track.hide()
				rotate_icon.hide()
			else:
				rotate_icon.position = grid_to_world_top_left(world_to_grid(get_global_mouse_position())) + Vector2(8, 8)
				rotate_icon.show()
				ghost_track.hide()
				ghost_train.hide()
		_:
			ghost_track.hide()
			ghost_train.hide()
			rotate_icon.hide()
			pass
			
	if Input.is_action_just_pressed("primary_action"):
		if tile == Constants.GridType.TRACK:
			if real_tile.permitted_rotations.size() > 1:
				real_tile.rotate_tile()
				return
			else:
				if PlayerData.current_trains > 0:
					var train_ins = train_scene.instantiate()
					train_ins.position = grid_to_world_top_left(tile_pos)
					add_child(train_ins)
					PlayerData.handle_make_train()
					GlobalAudio.play_sound_place_tile()
					return
		
	if Input.is_action_pressed("primary_action"):
		if tile == Constants.GridType.EMPTY and PlayerData.current_tracks > 0:
			set_grid_at_pos(tile_pos, Constants.GridType.TRACK)
			PlayerData.handle_build()
			GlobalAudio.play_sound_place_tile()
			get_tree().call_group("grid_tiles", "update_permitted_rotations")
	elif Input.is_action_pressed("secondary_action"):
		if tile == Constants.GridType.TRACK and real_tile.can_be_recycled:
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
	add_child(producer)
	
func spawn_train_at_position(grid_pos: Vector2) -> void:
	var train = train_scene.instantiate()
	train.position = grid_to_world_top_left(grid_pos)
	add_child(train)
	
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
