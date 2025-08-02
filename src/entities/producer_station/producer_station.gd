extends Area2D
class_name ProducerStation

var currently_produced = 1
var maximum_held_production = 1
	
func has_production_ready():
	return currently_produced > 0
	
func take_production():
	currently_produced -= 1
	update_state()

func _process(_delta: float):
	%hack_label.text = str(%decay_death_timer.time_left).pad_decimals(2)

func _on_resource_production_timer_timeout() -> void:
	currently_produced += 1
	update_state()

func update_state():
	%hack_label.hide()
	if currently_produced < maximum_held_production:
		%resource_production_timer.start()
		%decay_death_timer.stop()
	else:
		if %decay_death_timer.is_stopped():
			%decay_death_timer.start()
		%hack_label.show()

func _on_decay_death_timer_timeout() -> void:
	print("DED BY PRODUCTION TIMER DECAY")
