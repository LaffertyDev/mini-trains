extends Node2D
class_name GameController

var rail_grid_controller
var random = RandomNumberGenerator.new()
var levelups = 0

func _ready():
	random.randomize()
	rail_grid_controller = %rail_grid
	PlayerData.reset_game()
	%Hud.sync_gui()
	PlayerData.player_data_changed.connect(_on_player_data_change)
	get_tree().call_group("grid_tiles", "update_permitted_rotations")


func get_grid() -> GridController:
	return %rail_grid

func get_gui() -> GuiController:
	return %Hud

enum MouseClickState { None, Pressed }
var current_mouse_click_state = MouseClickState.None
var current_mouse_pressed_at = null

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
	if levelups == 0:
		%levelup_timer.start(30)
	elif levelups == 1:
		%levelup_timer.start(35)
	elif levelups == 2:
		%levelup_timer.start(60)
	else:
		%levelup_timer.start(%levelup_timer.wait_time + 5.0)
	GlobalAudio.play_sound_levelup()
	
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
			PlayerData.current_tracks += 20
			PlayerData.player_data_changed.emit()
			return
		distance_modifier += 1

func is_grid_valid(grid_position: Vector2) -> bool:
	for grid_x in range(-1, 3):
		for grid_y in range(-2, 4):
			var tile = rail_grid_controller.get_tile_at_pos(grid_position + Vector2(grid_x, grid_y))
			if tile != Constants.GridType.EMPTY:
				return false
	return true
