extends Node2D

var rail_grid_controller

func _ready():
	rail_grid_controller = %rail_grid
	PlayerData.reset_game()
	%Hud.sync_gui()
	PlayerData.player_data_changed.connect(_on_player_data_change)


func get_grid() -> GridController:
	return %rail_grid

func get_build_menu() -> BuildMenuController:
	return %BuildMenu


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			rail_grid_controller.handle_left_click()
			
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
