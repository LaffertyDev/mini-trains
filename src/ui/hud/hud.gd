extends Control


func sync_gui(player_data):
	%vrail_label.text = str(player_data.tracks_vertical)
	%hrail_label.text = str(player_data.tracks_horizontal)
	%train_label.text = str(player_data.trains)
	%junction90_label.text = str(player_data.tracks_junctions_90)
	%junctionX_label.text = str(player_data.tracks_junctions_x)
	pass
