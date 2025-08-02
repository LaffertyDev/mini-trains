extends Node2D
class_name Wagon

var halted = false

func set_movement_direction(direction: Vector2) -> void:
	%TrackEngine.set_direction(direction)

func _on_track_engine_direction_facing_change(direction: Constants.Direction) -> void:
	print('the fuck')
	pass # Replace with function body.

func move() -> void:
	%TrackEngine.move()

func stop() -> void:
	%TrackEngine.stop()
