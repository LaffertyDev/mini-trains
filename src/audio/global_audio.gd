extends Node

var is_playing_clock_of_doom = 0
var clock_of_doom_last_note_high = false
const clock_of_doom_default = 0.9
var clock_of_doom_timeout = clock_of_doom_default

func play_sound_defeat():
	%sound_defeat.play()
	
func play_sound_levelup():
	%sound_levelup.play()
	
func play_train_horn():
	%sound_train_horn.play()
	
func play_train_movement():
	%sound_train_chunkchunk.play()
	
func stop_train_movement():
	%sound_train_chunkchunk.stop()
	
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
	if is_playing_clock_of_doom == 0:
		clock_of_doom_timeout = clock_of_doom_default
		%clicking_tock_doom_ticktock.start(clock_of_doom_timeout)
		%sound_clock_tick_high.play()
		clock_of_doom_last_note_high = true
	is_playing_clock_of_doom += 1

func cancel_sound_ticking_clock_doom():
	is_playing_clock_of_doom -= 1
	
func cancel_sound_doom_completely():
	is_playing_clock_of_doom = 0
	%clicking_tock_doom_ticktock.stop()

func _on_clicking_tock_doom_ticktock_timeout() -> void:
	if is_playing_clock_of_doom > 0:
		clock_of_doom_timeout -= 0.01
		%clicking_tock_doom_ticktock.start(clock_of_doom_timeout)
		if clock_of_doom_last_note_high:
			%sound_clock_tick_low.play()
		else:
			%sound_clock_tick_high.play()
		clock_of_doom_last_note_high = not clock_of_doom_last_note_high
