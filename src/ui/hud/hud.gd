extends Control
class_name GuiController

var current_track_mode = Constants.GuiControlMode.NONE

func sync_gui():
	%rail_label.text = str(PlayerData.current_tracks)
	%train_label.text = str(PlayerData.current_trains)

func get_hud_control_mode() -> Constants.GuiControlMode:
	return current_track_mode

func _on_rail_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		current_track_mode = Constants.GuiControlMode.TRACK
		print("toggled on")
	else:
		current_track_mode = Constants.GuiControlMode.NONE
		print("toggled off")
