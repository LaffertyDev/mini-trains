extends Area2D
class_name ProducerStation

@export var currently_produced: bool = false
var is_playing_doom = false
	
func has_production_ready():
	return currently_produced
	
func take_production():
	currently_produced = false
	GlobalAudio.play_sound_cargo_dropoff()
	%loaded_till_decay_starts.stop()
	%decay_death_timer.stop()
	%decay_death_audio_start_timer.stop()
	%animated_sprite.play("loading")
	if is_playing_doom:
		GlobalAudio.cancel_sound_ticking_clock_doom()
		is_playing_doom = false
	
func _ready():
	add_to_group("producers")
	if currently_produced:
		%animated_sprite.play("loaded")
		%loaded_till_decay_starts.start()
	else:
		%animated_sprite.play("loading")

func _on_decay_death_timer_timeout() -> void:
	GlobalAudio.play_sound_defeat()
	GlobalAudio.cancel_sound_ticking_clock_doom()
	GlobalAudio.cancel_sound_doom_completely()
	get_tree().current_scene.on_defeat()

func _on_animated_sprite_animation_finished() -> void:
	if %animated_sprite.animation == "loading":
		%animated_sprite.play("loaded")
		if not currently_produced:
			currently_produced = true
			%loaded_till_decay_starts.start()

func _on_loaded_till_decay_starts_timeout() -> void:
	%animated_sprite.play("critical")
	%decay_death_timer.start()
	%decay_death_audio_start_timer.start()

func _on_decay_death_audio_start_timer_timeout() -> void:
	if %animated_sprite.animation == "critical":
		GlobalAudio.play_sound_ticking_clock_doom()
		is_playing_doom = true
