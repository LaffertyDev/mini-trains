extends Camera2D

@export var speed = 250
@export var zoom_speed = 0.004
var motion = Vector2()

var real_position = Vector2()

func _physics_process(delta):
	motion.x = 0
	motion.y = 0
	if Input.is_action_pressed("camera_left"):
		motion.x = -speed
	if Input.is_action_pressed("camera_right"):
		motion.x = speed
	if Input.is_action_pressed("camera_up"):
		motion.y = -speed
	if Input.is_action_pressed("camera_down"):
		motion.y = speed
	if Input.is_action_pressed("camera_zoom_in"):
		zoom.x += zoom_speed
		zoom.y += zoom_speed
	if Input.is_action_pressed("camera_zoom_out"):
		zoom.x -= zoom_speed
		zoom.y -= zoom_speed
		
	zoom.x = min(1.1, max(0.5, zoom.x))
	zoom.y = min(1.1, max(0.5, zoom.y))

	real_position += (motion * delta)
	position = Vector2(floor(real_position.x), floor(real_position.y))
