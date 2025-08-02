extends Node2D
class_name Wagon

var halted = false

func set_movement_direction(direction: Vector2) -> void:
	%TrackEngine.set_direction(direction)

func _on_track_engine_direction_facing_change(direction: Constants.Direction) -> void:
	match direction:
		Constants.Direction.left:
			%animated_sprite.play("moving_left")
		Constants.Direction.right:
			%animated_sprite.play("moving_right")
		Constants.Direction.bottom:
			%animated_sprite.play("moving_bottom")
		Constants.Direction.top:
			%animated_sprite.play("moving_top")

func move() -> void:
	%TrackEngine.move()

func stop() -> void:
	%TrackEngine.stop()
