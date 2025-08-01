extends Area2D

var tiles_per_second = 1.0

var speed = 20

var velocity = Vector2(-speed, 0)

var left: Area2D
var bottom: Area2D
var top: Area2D
var right: Area2D

func _ready():
	left = %left
	bottom = %bottom
	top = %top
	right = %right

func _physics_process(delta: float) -> void:
	self.position += (velocity * delta)
	
func handle_ded():
	print("ded")

func _on_left_area_entered(area: Area2D) ->void:
	print("left")
	handle_ded()
func _on_left_area_exited(area: Area2D) -> void:
	pass
func _on_right_area_entered(area: Area2D) -> void:
	handle_ded()
func _on_right_area_exited(area: Area2D) -> void:
	pass
func _on_top_area_entered(area: Area2D) -> void:
	handle_ded()
func _on_top_area_exited(area: Area2D) -> void:
	pass
func _on_bottom_area_entered(area: Area2D) -> void:
	handle_ded()
func _on_bottom_area_exited(area: Area2D) -> void:
	pass

func _on_center_area_entered(area: Area2D) -> void:
	if area.grid_type == Constants.GridType.RAIL_JUNCTION:
		var grid: GridController = get_tree().current_scene.get_grid()
		var grid_position = grid.world_to_grid(area.position)
		var train_position_in_grid = grid.grid_to_world_top_left(grid_position)
		self.position = train_position_in_grid
		
		# todo -- update train sprite to point in the propxer direction
		match area.junction_type:
			Constants.JunctionType.HORIZONTAL:
				# we do not turn
				pass
			Constants.JunctionType.VERTICAL:
				# we do not turn
				pass
			Constants.JunctionType.EAST_SOUTH:
				if velocity.x != 0:
					velocity = Vector2(0, speed)
				else:
					velocity = Vector2(speed, 0)
			Constants.JunctionType.EAST_NORTH:
				if velocity.x != 0:
					velocity = Vector2(0, -speed)
				else:
					velocity = Vector2(speed, 0)
			Constants.JunctionType.WEST_SOUTH:
				if velocity.x != 0:
					velocity = Vector2(0, -speed)
				else:
					velocity = Vector2(-speed, 0)
			Constants.JunctionType.WEST_NORTH:
				if velocity.x != 0:
					velocity = Vector2(0, -speed)
				else:
					velocity = Vector2(-speed, 0)
					
		if velocity.x < 0:
			%animated_sprite.play("moving_left")
		if velocity.x > 0:
			%animated_sprite.play("moving_right")
		if velocity.y < 0:
			%animated_sprite.play("moving_top")
		if velocity.y > 0:
			%animated_sprite.play("moving_bottom")


func _on_center_area_exited(area: Area2D) -> void:
	var grid: GridController = get_tree().current_scene.get_grid()
	var current_grid_position = grid.world_to_grid(area.position)
	var direction = Vector2(0, 0)
	
	if velocity.x < 0:
		direction.x -= 1
	if velocity.x > 0:
		direction.x += 1
	if velocity.y < 0:
		direction.y -= 1
	if velocity.y > 0:
		direction.y += 1
		
	var next_grid_tile = grid.get_tile_at_pos(current_grid_position + direction)
	if next_grid_tile == Constants.GridType.EMPTY:
		print("NEXT TILE EMPTY")
		handle_ded()
