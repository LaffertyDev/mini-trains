extends Node2D
class_name Train

var holding_cargo = false

var wagons_following = []

var wagon_res = preload("res://src/entities/wagon/wagon.tscn")

func _ready():
	var grid: GridController = get_tree().current_scene.get_grid()
	var grid_position = grid.world_to_grid(self.global_position)
	var grid_tile = grid.get_real_tile_at_pos(grid_position)
	if grid_tile == null:
		print("ERROR ERROR ERROR")
	else:
		var starting_direction
		match grid_tile.current_rotation:
			0:
				starting_direction = Vector2(-1, 0)
			1:
				starting_direction = Vector2(0, 1)
			2:
				starting_direction = Vector2(1, 0)
			3:
				starting_direction = Vector2(-1, 0)
			4:
				starting_direction = Vector2(-1, 0)
			5:
				starting_direction = Vector2(1, 0)
			6:
				starting_direction = Vector2(-1, 0)
			7:
				starting_direction = Vector2(0, 1)
			_:
				print("ERROR ERROR ERROR")
		self.position = grid.grid_to_world_top_left(grid_position)
		%TrackEngine.set_direction(starting_direction)
		%TrackEngine.move()
		GlobalAudio.play_train_movement()

func _on_track_engine_collide_with_terrain(_direction: Constants.Direction) -> void:
	get_parent().call_deferred("remove_child", self)
	self.call_deferred("queue_free")
	for w in wagons_following:
		w.get_parent().call_deferred("remove_child", w)
		w.call_deferred("queue_free")
	wagons_following = []
	GlobalAudio.stop_train_movement()

func _on_track_engine_direction_facing_change(direction: Constants.Direction) -> void:
	match direction:
		Constants.Direction.left:
			%animated_sprite.play("moving_left")
		Constants.Direction.right:
			%animated_sprite.play("moving_right")
		Constants.Direction.bottom:
			%animated_sprite.play("moving_bottom")
		Constants.Direction.top:
			%animated_sprite.play("moving_top")


func _on_track_engine_enter_station(station: Station) -> void:
	if holding_cargo:
		station.take_cargo()
		GlobalAudio.play_sound_cargo_dropoff()
		%stop_timer.start()
		self.holding_cargo = false
		%TrackEngine.stop()
		PlayerData.stat_loads_completed += 1
		for w in wagons_following:
			w.get_parent().call_deferred("remove_child", w)
			w.call_deferred("queue_free")
		wagons_following = []
		GlobalAudio.stop_train_movement()

func _on_stop_timer_timeout() -> void:
	%TrackEngine.move()
	GlobalAudio.play_train_movement()
	for w in wagons_following:
		w.move()

func _on_track_engine_enter_producer(producer: ProducerStation) -> void:
	if producer.has_production_ready() and not holding_cargo:
		producer.take_production()
		GlobalAudio.play_sound_cargo_dropoff()
		%stop_timer.start()
		self.holding_cargo = true
		%TrackEngine.stop()
		GlobalAudio.stop_train_movement()
		
		var wagon = wagon_res.instantiate()
		wagon.position = self.position - (%TrackEngine.movement_direction * 19)
		wagon.set_movement_direction(%TrackEngine.movement_direction)
		wagons_following.append(wagon)
		wagon.stop()
		get_parent().call_deferred("add_child", wagon)
