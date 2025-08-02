extends Control


func sync_gui():
	%vrail_label.text = str(PlayerData.current_tracks_vertical)
	%hrail_label.text = str(PlayerData.current_tracks_horizontal)
	%train_label.text = str(PlayerData.current_trains)
	%junction90_label.text = str(PlayerData.current_tracks_junctions_90)
	%junctionX_label.text = str(PlayerData.current_tracks_junctions_x)
