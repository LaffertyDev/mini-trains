extends Control
class_name GuiController

func sync_gui():
	%rail_label.text = str(PlayerData.current_tracks)
	%train_label.text = str(PlayerData.current_trains)
