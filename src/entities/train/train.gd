extends Node2D
class_name Train

var holding_cargo = false

var wagons_following = []

var wagon_res = preload("res://src/entities/wagon/wagon.tscn")

func _ready():
	var grid: GridController = get_tree().current_scene.get_grid()
	var grid_position = grid.world_to_grid(self.global_position)
	var grid_tile = grid.get_tile_at_pos(grid_position)
	var starting_direction
	match grid_tile:
		Constants.GridType.RAIL_HORIZONTAL:
			starting_direction = Vector2(-1, 0)
		Constants.GridType.RAIL_VERTICAL:
			starting_direction = Vector2(0, 1)
		_:
			print("ERROR ERROR ERROR ERROR")
	self.position = grid.grid_to_world_top_left(grid_position)
	%TrackEngine.set_direction(starting_direction)
	%TrackEngine.move()

func _on_track_engine_collide_with_terrain(_direction: Constants.Direction) -> void:
	print('ded')
	pass # Replace with function body.

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
		for w in wagons_following:
			w.get_parent().call_deferred("remove_child", w)
			w.call_deferred("queue_free")
		wagons_following = []

func _on_stop_timer_timeout() -> void:
	%TrackEngine.move()
	for w in wagons_following:
		w.move()

func _on_track_engine_enter_producer(producer: ProducerStation) -> void:
	if producer.has_production_ready() and not holding_cargo:
		producer.take_production()
		GlobalAudio.play_sound_cargo_dropoff()
		%stop_timer.start()
		self.holding_cargo = true
		%TrackEngine.stop()
		
		var wagon = wagon_res.instantiate()
		wagon.position = self.position - (%TrackEngine.movement_direction * 19)
		wagon.set_movement_direction(%TrackEngine.movement_direction)
		wagons_following.append(wagon)
		wagon.stop()
		get_parent().call_deferred("add_child", wagon)
