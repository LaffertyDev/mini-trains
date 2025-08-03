@tool

extends Area2D
class_name GridTile

@export var grid_type: Constants.GridType = Constants.GridType.EMPTY:
	set(new_resource):
		grid_type = new_resource

var current_rotation = null
var permitted_rotations = []

func _ready():
	add_to_group("grid_tiles")
	update_permitted_rotations()
	
func rotate_tile():
	var rotation_idx = -1
	for i in range(permitted_rotations.size()):
		if current_rotation == permitted_rotations[i]:
			rotation_idx = i
			break
	
	if rotation_idx == -1:
		current_rotation = permitted_rotations[0]
	else:
		current_rotation = permitted_rotations[(rotation_idx + 1) % permitted_rotations.size()]
		pass
	set_sprite_match_rotation()
	GlobalAudio.play_sound_rotate_junction()

func set_sprite_match_rotation() -> void:
	%sprite.frame = current_rotation

func update_permitted_rotations() -> void:
	var grid_controller = get_tree().current_scene.get_grid()
	var my_position = grid_controller.world_to_grid(self.global_position)
	var has_neighbor_top = grid_controller.get_tile_at_pos(my_position + Vector2(0, -1)) == Constants.GridType.TRACK
	var has_neighbor_bottom = grid_controller.get_tile_at_pos(my_position + Vector2(0, 1)) == Constants.GridType.TRACK
	var has_neighbor_left = grid_controller.get_tile_at_pos(my_position + Vector2(-1, 0)) == Constants.GridType.TRACK
	var has_neighbor_right = grid_controller.get_tile_at_pos(my_position + Vector2(1, 0)) == Constants.GridType.TRACK

	var rotations = []
	if has_neighbor_left and has_neighbor_right and !has_neighbor_top and !has_neighbor_bottom:
		rotations.append(0)
	if has_neighbor_bottom and has_neighbor_top and !has_neighbor_left and !has_neighbor_right:
		rotations.append(1)
	if has_neighbor_bottom and has_neighbor_right:
		rotations.append(2)
	if has_neighbor_left and has_neighbor_bottom:
		rotations.append(3)
	if has_neighbor_top and has_neighbor_left:
		rotations.append(4)
	if has_neighbor_top and has_neighbor_right:
		rotations.append(5)
	
	if has_neighbor_left and has_neighbor_right and (has_neighbor_top or has_neighbor_bottom):
		rotations.append(6)
	if has_neighbor_top and has_neighbor_bottom and (has_neighbor_left or has_neighbor_right):
		rotations.append(7)
		
	if rotations.size() == 0:
		if has_neighbor_left or has_neighbor_right:
			rotations.append(0)
		else:
			rotations.append(1)

	permitted_rotations = rotations
	
	# if my current rotation, or an equivalent rotation, is in the array
	# then use it
	
	var current_idx = permitted_rotations.find(current_rotation)
	if (current_idx == -1):
		if current_rotation == 0:
			if permitted_rotations.has(6):
				current_rotation = 6
			else:
				current_rotation = permitted_rotations[0]
		elif current_rotation == 6:
			if permitted_rotations.has(0):
				current_rotation = 0
			else:
				current_rotation = permitted_rotations[0]
		elif current_rotation == 1:
			if permitted_rotations.has(7):
				current_rotation = 7
			else:
				current_rotation = permitted_rotations[0]
		elif current_rotation == 7:
			if permitted_rotations.has(1):
				current_rotation = 1
			else:
				current_rotation = permitted_rotations[0]
		else:
			current_rotation = permitted_rotations[0]
	else:
		# our current rotation is in the array
		# so there's nothing to do, we're already using it
		pass
	
		# is there an equivalent?
	set_sprite_match_rotation()
