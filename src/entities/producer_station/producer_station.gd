extends Area2D
class_name ProducerStation

var currently_produced = 1
var maximum_held_production = 1
var is_playing_doom = false
	
func has_production_ready():
	return currently_produced > 0
	
func take_production():
	currently_produced -= 1
	GlobalAudio.play_sound_cargo_dropoff()
	%loaded_till_decay_starts.stop()
	%decay_death_timer.stop()
	%decay_death_audio_start_timer.stop()
	%animated_sprite.play("loading")
	if is_playing_doom:
		GlobalAudio.cancel_sound_ticking_clock_doom()
		is_playing_doom = false
	%hack_label.hide()
	
func _ready():
	add_to_group("producers")
	%animated_sprite.play("loaded")
	%loaded_till_decay_starts.start()

func _process(_delta: float):
	%hack_label.text = str(%decay_death_timer.time_left).pad_decimals(0)

func _on_decay_death_timer_timeout() -> void:
	GlobalAudio.play_sound_defeat()
	GlobalAudio.cancel_sound_ticking_clock_doom()
	GlobalAudio.cancel_sound_doom_completely()
	get_tree().current_scene.on_defeat()

func _on_animated_sprite_animation_finished() -> void:
	if %animated_sprite.animation == "loading":
		%animated_sprite.play("loaded")
		if currently_produced < maximum_held_production:
			currently_produced += 1
			%loaded_till_decay_starts.start()

func _on_loaded_till_decay_starts_timeout() -> void:
	%animated_sprite.play("critical")
	%decay_death_timer.start()
	%decay_death_audio_start_timer.start()
	%hack_label.show()

func _on_decay_death_audio_start_timer_timeout() -> void:
	if %animated_sprite.animation == "critical":
		GlobalAudio.play_sound_ticking_clock_doom()
		is_playing_doom = true
