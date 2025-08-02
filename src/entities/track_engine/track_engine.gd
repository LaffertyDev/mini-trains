extends Node2D
class_name TrackEngine

var tiles_per_second = 1.0

var speed = 20
var stopped = false
var movement_direction = Vector2(-1, 0)

signal direction_facing_change(direction: Constants.Direction)
signal collide_with_terrain(direction: Constants.Direction)
signal enter_station(station: Station)
signal enter_producer(producer: ProducerStation)

func _ready():
	emit_direction()
	
func set_direction(direction: Vector2) -> void:
	self.movement_direction = direction
	emit_direction()

func emit_direction():
	if movement_direction.x < 0:
		direction_facing_change.emit(Constants.Direction.left)
	if movement_direction.x > 0:
		direction_facing_change.emit(Constants.Direction.right)
	if movement_direction.y < 0:
		direction_facing_change.emit(Constants.Direction.top)
	if movement_direction.y > 0:
		direction_facing_change.emit(Constants.Direction.bottom)
		
func stop() -> void:
	stopped = true
	
func move() -> void:
	stopped = false

func lock_position_to_tile() -> void:
	var grid: GridController = get_tree().current_scene.get_grid()
	var grid_position = grid.world_to_grid(get_parent().global_position)
	var train_position_in_grid = grid.grid_to_world_top_left(grid_position)
	self.position = train_position_in_grid

func _physics_process(delta: float) -> void:
	if not stopped:
		# we only move if the stop timer isn't running, i.e. we are moving
		get_parent().position += (movement_direction * speed * delta)

func _on_left_area_entered(_area: Area2D) ->void:
	collide_with_terrain.emit(Constants.Direction.left)
func _on_left_area_exited(_area: Area2D) -> void:
	pass
func _on_right_area_entered(_area: Area2D) -> void:
	collide_with_terrain.emit(Constants.Direction.right)
func _on_right_area_exited(_area: Area2D) -> void:
	pass
func _on_top_area_entered(_area: Area2D) -> void:
	collide_with_terrain.emit(Constants.Direction.top)
func _on_top_area_exited(_area: Area2D) -> void:
	pass
func _on_bottom_area_entered(_area: Area2D) -> void:
	collide_with_terrain.emit(Constants.Direction.bottom)
func _on_bottom_area_exited(_area: Area2D) -> void:
	pass

func _on_center_area_entered(area: Area2D) -> void:
	var producer_station := area as ProducerStation
	if producer_station:
		enter_producer.emit(producer_station)
	var station := area as Station
	if station:
		enter_station.emit(station)
	var tile := area as GridTile
	if tile:
		if area.grid_type == Constants.GridType.RAIL_JUNCTION_X or area.grid_type == Constants.GridType.RAIL_JUNCTION_90:
			var grid: GridController = get_tree().current_scene.get_grid()
			var grid_position = grid.world_to_grid(area.global_position)
			var train_position_in_grid = grid.grid_to_world_top_left(grid_position)
			get_parent().position = train_position_in_grid
			
			match area.junction_type:
				Constants.JunctionType.HORIZONTAL:
					# we do not turn
					pass
				Constants.JunctionType.VERTICAL:
					# we do not turn
					pass
				Constants.JunctionType.EAST_SOUTH:
					if movement_direction.x != 0:
						movement_direction = Vector2(0, 1)
					else:
						movement_direction = Vector2(1, 0)
					emit_direction()
				Constants.JunctionType.EAST_NORTH:
					if movement_direction.x != 0:
						movement_direction = Vector2(0, -1)
					else:
						movement_direction = Vector2(1, 0)
					emit_direction()
				Constants.JunctionType.WEST_SOUTH:
					if movement_direction.x != 0:
						movement_direction = Vector2(0, 1)
					else:
						movement_direction = Vector2(-1, 0)
					emit_direction()
				Constants.JunctionType.WEST_NORTH:
					if movement_direction.x != 0:
						movement_direction = Vector2(0, -1)
					else:
						movement_direction = Vector2(-1, 0)
					emit_direction()

func _on_center_area_exited(area: Area2D) -> void:
	var grid: GridController = get_tree().current_scene.get_grid()
	var current_grid_position = grid.world_to_grid(area.global_position)
	var next_grid_tile = grid.get_tile_at_pos(current_grid_position + movement_direction)
	if next_grid_tile == Constants.GridType.EMPTY:
		collide_with_terrain.emit(Constants.Direction.left) # TODO - MAKE DYNAMIC
