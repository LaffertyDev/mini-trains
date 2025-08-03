#extends Node2D
#class_name BuildMenuController
#
#var button_base_texture = preload("res://src/ui/ui_build_button_border.png")
#
#var options_to_sprite = {
	#Constants.BuildOptions.RECYCLE: preload("res://src/ui/ui_recycle_button.png"),
	#Constants.BuildOptions.TRAIN: preload("res://src/ui/build_menu/train_base.png"),
	#Constants.BuildOptions.RAIL_VERTICAL: preload("res://src/entities/gridtile/rail_vertical.png"),
	#Constants.BuildOptions.RAIL_HORIZONTAL: preload("res://src/entities/gridtile/rail_horizontal.png"),
	#Constants.BuildOptions.RAIL_JUNCTION_X: preload("res://src/ui/build_menu/rail_junction_horizontal_base.png"),
	#Constants.BuildOptions.RAIL_JUNCTION_90: preload("res://src/ui/build_menu/rail_junction_90_base.png"),
#}
#
#var player_resources = {
	#"tracks_horizontal": 0,
	#"tracks_vertical": 0,
	#"tracks_junctions_90": 0,
	#"tracks_junctions_x": 0,
	#"trains": 0
#}
#signal option_was_built(option: Constants.BuildOptions)
#
#func setup_build_options(for_tile_type: Constants.GridType) -> void:
	#var options = []
	#match for_tile_type:
		#Constants.GridType.EMPTY:
			#if PlayerData.current_tracks_horizontal > 0:
				#options.append(Constants.BuildOptions.RAIL_HORIZONTAL)
			#if PlayerData.current_tracks_vertical > 0:
				#options.append(Constants.BuildOptions.RAIL_VERTICAL)
			#if PlayerData.current_tracks_junctions_90 > 0:
				#options.append(Constants.BuildOptions.RAIL_JUNCTION_90)
			#if PlayerData.current_tracks_junctions_x > 0:
				#options.append(Constants.BuildOptions.RAIL_JUNCTION_X)
		#_:
			#if PlayerData.current_trains > 0:
				#options.append(Constants.BuildOptions.TRAIN)
			#options.append(Constants.BuildOptions.RECYCLE)
	#
	#for c in get_children():
		#c.queue_free()
		#remove_child(c)
	#
	#var radius = 20
	#var center = Vector2(8, 8)
	#var button_size: Vector2 = Vector2(20, 20)
	#
	#var num_buttons = options.size()
	#var angle_step = 2 * PI / num_buttons
	#
	#for i in range(num_buttons):
		#var area = Area2D.new()
		#var collision = CollisionShape2D.new()
		#var rect_shape = RectangleShape2D.new()
		#rect_shape.size = button_size
		#collision.shape = rect_shape
		#area.add_child(collision)
		#
		## Create Sprite2D
		#var background_texture = Sprite2D.new() # 20/20
		#background_texture.texture = button_base_texture
		#area.add_child(background_texture)
		#
		#var sprite = Sprite2D.new() #16/16
		#sprite.texture = options_to_sprite[options[i]]
	##	sprite.position = Vector2(1, 1)
		#area.add_child(sprite)
		#
		#var angle = i * angle_step
		#var x = radius * cos(angle) + center.x
		#var y = radius * sin(angle) + center.y
		#area.position = Vector2(x, y)
		#
		#add_child(area)
		#area.input_event.connect(_handle_pressed.bind(options[i]))
#
#func _handle_pressed(_viewport: Node, event: InputEvent, _shape_idx: int, build_option: Constants.BuildOptions):	
	#if event is InputEventMouseButton:
		#var mouse_event = event as InputEventMouseButton
		#if mouse_event.button_index == MOUSE_BUTTON_LEFT:
			#option_was_built.emit(build_option)
