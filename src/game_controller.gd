extends Node2D

var rail_grid_controller
var random = RandomNumberGenerator.new()

func _ready():
	random.randomize()
	rail_grid_controller = %rail_grid
	PlayerData.reset_game()
	%Hud.sync_gui()
	PlayerData.player_data_changed.connect(_on_player_data_change)


func get_grid() -> GridController:
	return %rail_grid

func get_build_menu() -> BuildMenuController:
	return %BuildMenu


enum MouseClickState { None, Pressed }
var current_mouse_click_state = MouseClickState.None
var current_mouse_pressed_at = null

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				current_mouse_click_state = MouseClickState.Pressed
				current_mouse_pressed_at = get_global_mouse_position()
			else:
				if current_mouse_click_state == MouseClickState.Pressed:
					var distance = get_global_mouse_position() - current_mouse_pressed_at
					if abs(distance.length()) < 5:
						rail_grid_controller.handle_left_click()
				current_mouse_click_state = MouseClickState.None
			
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			rail_grid_controller.handle_right_click()
	
func _on_player_data_change():
	%Hud.sync_gui()
	
func on_defeat() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.BLACK, 2).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(switch_scene_to_defeat)

func switch_scene_to_defeat():
	get_tree().change_scene_to_file("res://src/ui/end_round_screen/end_round_screen.tscn")

func _on_levelup_timer_timeout() -> void:
	var producers = get_tree().get_nodes_in_group("producers")
	var distance_modifier = 30
	
	var inner_radius = max(1, int(producers.size() * 0.25))
	var outer_radius = max(2, int(producers.size() * 1.25))

	# spawn in a random spot on a circle with radius of the number of producers
	while(true):
		var random_degrees = random.randi() % 360
		var x = cos(random_degrees)
		var y = sin(random_degrees)
		var random_radius = (random.randi() % outer_radius) + inner_radius
		var random_position = Vector2(x, y) * random_radius * distance_modifier
		
		var grid_position = rail_grid_controller.world_to_grid(random_position)
		if is_grid_valid(grid_position):
			rail_grid_controller.setup_producer_at_pos(grid_position)
			PlayerData.current_trains += 1
			PlayerData.current_tracks_horizontal += 10
			PlayerData.current_tracks_vertical += 10
			PlayerData.current_tracks_junctions_90 += 2
			PlayerData.current_tracks_junctions_x += 2
			return
		distance_modifier += 1

func is_grid_valid(grid_position: Vector2) -> bool:
	for grid_x in range(-1, 3):
		for grid_y in range(-2, 4):
			var tile = rail_grid_controller.get_tile_at_pos(grid_position + Vector2(grid_x, grid_y))
			if tile != Constants.GridType.EMPTY:
				return false
	return true
