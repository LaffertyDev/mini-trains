extends Node2D
class_name Train

var holding_cargo = false

var wagons_following = []

var wagon_res = preload("res://src/entities/wagon/wagon.tscn")
var current_direction
var moving = true

func _ready():
	add_to_group("trains")
		
func grid_initialize():
	var grid_controller = GameCoordinator.get_grid_controller()
	var grid_position = grid_controller.world_to_grid(self.global_position)
	var grid_tile = grid_controller.get_real_tile_at_pos(grid_position)
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
		self.position = grid_controller.grid_to_world_top_left(grid_position)
		%TrackEngine.set_direction(starting_direction)
		start_moving()
	
		
func stop_moving():
	%TrackEngine.stop()
	moving = false
	GlobalAudio.stop_train_movement()
	
	if current_direction:
		match current_direction:
			Constants.Direction.left:
				%animated_sprite.play("idle_left")
			Constants.Direction.right:
				%animated_sprite.play("idle_right")
			Constants.Direction.bottom:
				%animated_sprite.play("idle_bottom")
			Constants.Direction.top:
				%animated_sprite.play("idle_top")
	
	
func start_moving():
	%TrackEngine.move()
	GlobalAudio.play_train_movement()
	%animated_sprite.play()
	moving = true
	for w in wagons_following:
		w.move()
		
	if current_direction:
		match current_direction:
			Constants.Direction.left:
				%animated_sprite.play("moving_left")
			Constants.Direction.right:
				%animated_sprite.play("moving_right")
			Constants.Direction.bottom:
				%animated_sprite.play("moving_bottom")
			Constants.Direction.top:
				%animated_sprite.play("moving_top")

func _on_track_engine_collide_with_terrain(_direction: Constants.Direction) -> void:
	var rail_tween_color = get_tree().create_tween()
	
	rail_tween_color.tween_property(%animated_sprite, "modulate:v", 1, 0.05).from(15) 
	stop_moving()
	
	await get_tree().create_timer(0.05).timeout
	
	get_parent().call_deferred("remove_child", self)
	self.call_deferred("queue_free")
	for w in wagons_following:
		w.get_parent().call_deferred("remove_child", w)
		w.call_deferred("queue_free")
	wagons_following = []
	GlobalAudio.play_train_crash()
	GlobalAudio.stop_train_movement()
	
	var game_controller = GameCoordinator.get_game_controller()
	game_controller.on_train_died()

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
	current_direction = direction


func _on_track_engine_enter_station(station: Station) -> void:
	if holding_cargo:
		station.take_cargo()
		%stop_timer.start()
		self.holding_cargo = false
		for w in wagons_following:
			w.get_parent().call_deferred("remove_child", w)
			w.call_deferred("queue_free")
		wagons_following = []
		stop_moving()

func _on_stop_timer_timeout() -> void:
	start_moving()

func _on_track_engine_enter_producer(producer: ProducerStation) -> void:
	if producer.has_production_ready() and not holding_cargo:
		producer.take_production()
		%stop_timer.start()
		stop_moving()
		self.holding_cargo = true
		
		var wagon = wagon_res.instantiate()
		wagon.position = self.position - (%TrackEngine.movement_direction * 20)
		wagon.set_movement_direction(%TrackEngine.movement_direction)
		wagons_following.append(wagon)
		wagon.stop()
		get_parent().call_deferred("add_child", wagon)
