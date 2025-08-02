extends Node2D



var options_to_sprite = {
	Constants.BuildOptions.TRAIN: preload("res://src/ui/build_menu/train_base.png"),
	Constants.BuildOptions.RAIL_VERTICAL: preload("res://src/entities/gridtile/rail_vertical.png"),
	Constants.BuildOptions.RAIL_HORIZONTAL: preload("res://src/entities/gridtile/rail_horizontal.png"),
	Constants.BuildOptions.RAIL_JUNCTION_X: preload("res://src/ui/build_menu/rail_junction_horizontal_base.png"),
	Constants.BuildOptions.RAIL_JUNCTION_90: preload("res://src/ui/build_menu/rail_junction_90_base.png"),
}

signal option_was_built(option: Constants.BuildOptions)

func setup_build_options(for_tile_type: Constants.GridType) -> void:
	var options
	match for_tile_type:
		Constants.GridType.EMPTY:
			options = [
				Constants.BuildOptions.RAIL_VERTICAL,
				Constants.BuildOptions.RAIL_HORIZONTAL,
				Constants.BuildOptions.RAIL_JUNCTION_X,
				Constants.BuildOptions.RAIL_JUNCTION_90,
			]
		_:
			options = [
				Constants.BuildOptions.TRAIN,
			]
	
	for c in get_children():
		c.queue_free()
		remove_child(c)
	
	var radius = 32
	var center = Vector2(8, 8)
	
	var num_buttons = options.size()
	var angle_step = 2 * PI / num_buttons
	var button_size = 20
	
	for i in range(num_buttons):
		var ui_button = Button.new()
		var angle = i * angle_step
		var x = center.x + radius * cos(angle) - button_size / 2
		var y = center.y + radius * sin(angle) - button_size / 2
		ui_button.position = Vector2(x, y)
		ui_button.pressed.connect(_handle_pressed.bind(options[i]))
		ui_button.icon = options_to_sprite[options[i]]
		add_child(ui_button)

func _handle_pressed(build_option: Constants.BuildOptions) -> void:
	option_was_built.emit(build_option)
