extends Area2D
class_name ProducerStation

var currently_produced = 0
var maximum_held_production = 1
	
func has_production_ready():
	return currently_produced > 0
	
func take_production():
	currently_produced -= 1
	update_state()
	
func _ready():
	add_to_group("producers")

func _process(_delta: float):
	%hack_label.text = str(%decay_death_timer.time_left).pad_decimals(2)

func _on_resource_production_timer_timeout() -> void:
	if currently_produced < maximum_held_production:
		currently_produced += 1
		update_state()

func update_state():
	%hack_label.hide()
	if currently_produced < maximum_held_production:
		%resource_production_timer.start()
		%decay_death_timer.stop()
		GlobalAudio.cancel_sound_ticking_clock_doom()
	else:
		%resource_production_timer.stop()
		if %decay_death_timer.is_stopped():
			%decay_death_timer.start()
			GlobalAudio.play_sound_ticking_clock_doom()
		%hack_label.show()

func _on_decay_death_timer_timeout() -> void:
	GlobalAudio.play_sound_defeat()
	GlobalAudio.cancel_sound_ticking_clock_doom()
	get_tree().current_scene.on_defeat()
