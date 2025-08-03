extends Area2D
class_name ProducerStation

var currently_produced = 0
var maximum_held_production = 1
	
func has_production_ready():
	return currently_produced > 0
	
func take_production():
	currently_produced -= 1
	%loaded_till_decay_starts.stop()
	%decay_death_timer.stop()
	%animated_sprite.play("loading")
	GlobalAudio.cancel_sound_ticking_clock_doom()
	%hack_label.hide()
	
func _ready():
	add_to_group("producers")
	%animated_sprite.play("loading")

func _process(_delta: float):
	%hack_label.text = str(%decay_death_timer.time_left).pad_decimals(2)

func _on_decay_death_timer_timeout() -> void:
	GlobalAudio.play_sound_defeat()
	GlobalAudio.cancel_sound_ticking_clock_doom()
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
	%hack_label.show()
	GlobalAudio.play_sound_ticking_clock_doom()
