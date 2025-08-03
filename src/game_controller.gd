extends Node2D
class_name GameController

var rail_grid_controller
var random = RandomNumberGenerator.new()

func _ready():
	add_to_group("game_controller")
	random.randomize()
	rail_grid_controller = %rail_grid
	PlayerData.reset_game()
	GlobalAudio.play_train_horn()
	%Hud.sync_gui(false)
	PlayerData.player_data_changed.connect(_on_player_data_change)
	get_tree().call_group("grid_tiles", "update_permitted_rotations")


func get_grid() -> GridController:
	return %rail_grid

func get_gui() -> GuiController:
	return %Hud

func _on_player_data_change():
	%Hud.sync_gui(true)
	
func on_load_dropoff():
	if random.randi() % 100 > 75:
		PlayerData.current_trains += 1
	else:
		PlayerData.current_tracks += 20
		
	PlayerData.player_data_changed.emit()
	if %levelup_timer.is_stopped():
		%levelup_timer.start()
	
func spawn_producer():
	var distance_modifier = 30
	
	var new_wait_time = max(30.0, %levelup_timer.wait_time + 5.0)
	%levelup_timer.start(new_wait_time)
	GlobalAudio.play_sound_levelup()
	PlayerData.handle_level_up()
	
	var inner_radius = max(1, int(PlayerData.level_ups * 0.25))
	var outer_radius = max(2, int(PlayerData.level_ups * 1.25))

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
			return
		distance_modifier += 1
	
	
func on_defeat() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.BLACK, 2).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(switch_scene_to_defeat)

func switch_scene_to_defeat():
	get_tree().change_scene_to_file("res://src/ui/end_round_screen/end_round_screen.tscn")

func _on_levelup_timer_timeout() -> void:
	spawn_producer()
		
func on_train_died() -> void:
	await get_tree().create_timer(3.0).timeout
	PlayerData.handle_recycle_trains()# Do some action

func is_grid_valid(grid_position: Vector2) -> bool:
	for grid_x in range(-1, 3):
		for grid_y in range(-2, 4):
			var tile = rail_grid_controller.get_tile_at_pos(grid_position + Vector2(grid_x, grid_y))
			if tile != Constants.GridType.EMPTY:
				return false
	return true
