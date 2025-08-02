extends Node

var is_playing_clock_of_doom = false
var clock_of_doom_high = false
var clock_of_doom_timeout = 0.6

func play_sound_defeat():
	%sound_defeat.play()
	
func play_sound_rotate_junction():
	%sound_place_rotate_junction.play()
	
func play_sound_place_tile():
	%sound_place_build_track.play()
	
func play_sound_recycle_tile():
	%sound_place_recycle_track.play()

func play_sound_cargo_pickup():
	%sound_cargo_pickup.play()
	
func play_sound_cargo_dropoff():
	%sound_cargo_dropoff.play()
	
func play_sound_click_tile():
	%sound_click_tile.play()

func play_sound_ticking_clock_doom():
	if not is_playing_clock_of_doom:
		is_playing_clock_of_doom = true
		clock_of_doom_timeout = 0.6
		set_clock_doom_state()

func cancel_sound_ticking_clock_doom():
	is_playing_clock_of_doom = false

func _on_clicking_tock_doom_ticktock_timeout() -> void:
	set_clock_doom_state()
			
func set_clock_doom_state():
	if is_playing_clock_of_doom:
		clock_of_doom_high = not clock_of_doom_high
		%clicking_tock_doom_ticktock.wait_time = clock_of_doom_timeout
		if clock_of_doom_high:
			%sound_clock_tick_low.play()
		else:
			%sound_clock_tick_high.play()
		if %clicking_tock_doom_ticktock.is_stopped():
			clock_of_doom_timeout -= 0.01
			%clicking_tock_doom_ticktock.wait_time = clock_of_doom_timeout
			%clicking_tock_doom_ticktock.start()
