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
	var rotation_idx = permitted_rotations.find(current_rotation)
	if rotation_idx == -1:
		current_rotation = permitted_rotations[0]
		pass
	else:
		current_rotation = (rotation_idx + 1) % permitted_rotations.size()
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
	if not has_neighbor_top and not has_neighbor_bottom:
		# simple horizontal
		rotations.append(0)
	elif not has_neighbor_left and not has_neighbor_right:
		# simple vertical
		rotations.append(1)
	elif has_neighbor_bottom and has_neighbor_top and has_neighbor_left and has_neighbor_right:
		rotations = [6, 7]
	else:
		if has_neighbor_bottom and has_neighbor_right:
			rotations.append(2)
		if has_neighbor_left and has_neighbor_bottom:
			rotations.append(3)
		if has_neighbor_top and has_neighbor_left:
			rotations.append(4)
		if has_neighbor_top and has_neighbor_right:
			rotations.append(5)
	
	permitted_rotations = rotations
	var has_rotation = true
	for r in permitted_rotations:
		has_rotation = (has_rotation and current_rotation == r)
	
	if current_rotation == null or not has_rotation:
		current_rotation = permitted_rotations[0]
	set_sprite_match_rotation()
