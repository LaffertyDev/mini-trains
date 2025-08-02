class_name GridTile

extends Area2D

var tiles_per_second = 1.0

var speed = 20

var holding_cargo = false

var movement_direction = Vector2(-speed, 0)

var left: Area2D
var bottom: Area2D
var top: Area2D
var right: Area2D

enum Direction {left, top, bottom, right}
@export var InitialDirection: Direction = Direction.right

func set_speed():
	match InitialDirection:
		Direction.left:
			self.movement_direction = Vector2(-1, 0)
		Direction.right:
			self.movement_direction = Vector2(1, 0)
		Direction.bottom:
			self.movement_direction = Vector2(0, 1)
		Direction.top:
			self.movement_direction = Vector2(0, -1)
	set_anim_match_direction()

func set_anim_match_direction():
	if movement_direction.x < 0:
		%animated_sprite.play("moving_left")
	if movement_direction.x > 0:
		%animated_sprite.play("moving_right")
	if movement_direction.y < 0:
		%animated_sprite.play("moving_top")
	if movement_direction.y > 0:
		%animated_sprite.play("moving_bottom")

func _ready():
	left = %left
	bottom = %bottom
	top = %top
	right = %right
	set_speed()

func _physics_process(delta: float) -> void:
	if %stop_timer.is_stopped():
		# we only move if the stop timer isn't running, i.e. we are moving
		self.position += (movement_direction * speed * delta)
	
func handle_ded():
	print("ded")

func _on_left_area_entered(area: Area2D) ->void:
	print("left")
	handle_ded()
func _on_left_area_exited(area: Area2D) -> void:
	pass
func _on_right_area_entered(area: Area2D) -> void:
	print("right")
	handle_ded()
func _on_right_area_exited(area: Area2D) -> void:
	pass
func _on_top_area_entered(area: Area2D) -> void:
	print("top")
	handle_ded()
func _on_top_area_exited(area: Area2D) -> void:
	pass
func _on_bottom_area_entered(area: Area2D) -> void:
	print("bottom")
	handle_ded()
func _on_bottom_area_exited(area: Area2D) -> void:
	pass

func _on_center_area_entered(area: Area2D) -> void:
	var producer_station := area as ProducerStation
	if producer_station:
		if producer_station.has_production_ready() and not holding_cargo:
			producer_station.take_production()
			self.holding_cargo = true
			%stop_timer.start()
			var grid: GridController = get_tree().current_scene.get_grid()
			var grid_position = grid.world_to_grid(area.global_position)
			var train_position_in_grid = grid.grid_to_world_top_left(grid_position)
			self.position = train_position_in_grid
	var station := area as Station
	if station:
		if holding_cargo:
			station.take_cargo()
			self.holding_cargo = false
			%stop_timer.start()
			var grid: GridController = get_tree().current_scene.get_grid()
			var grid_position = grid.world_to_grid(area.global_position)
			var train_position_in_grid = grid.grid_to_world_top_left(grid_position)
			self.position = train_position_in_grid
	if area.is_in_group("grid_tiles") and area.grid_type == Constants.GridType.RAIL_JUNCTION:
		var grid: GridController = get_tree().current_scene.get_grid()
		var grid_position = grid.world_to_grid(area.global_position)
		var train_position_in_grid = grid.grid_to_world_top_left(grid_position)
		self.position = train_position_in_grid
		
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
			Constants.JunctionType.EAST_NORTH:
				if movement_direction.x != 0:
					movement_direction = Vector2(0, -1)
				else:
					movement_direction = Vector2(1, 0)
			Constants.JunctionType.WEST_SOUTH:
				if movement_direction.x != 0:
					movement_direction = Vector2(0, 1)
				else:
					movement_direction = Vector2(-1, 0)
			Constants.JunctionType.WEST_NORTH:
				if movement_direction.x != 0:
					movement_direction = Vector2(0, -1)
				else:
					movement_direction = Vector2(-1, 0)
		set_anim_match_direction()


func _on_center_area_exited(area: Area2D) -> void:
	var grid: GridController = get_tree().current_scene.get_grid()
	var current_grid_position = grid.world_to_grid(area.global_position)
	var next_grid_tile = grid.get_tile_at_pos(current_grid_position + movement_direction)
	if next_grid_tile == Constants.GridType.EMPTY:
		handle_ded()

func _on_stop_timer_timeout() -> void:
	pass # Replace with function body.
