extends Camera2D

const C = preload("res://utility/constants.gd")

var drag_enabled = false
var drag_start_pos = Vector2()
var target_pos = Vector2()

func _ready():
	make_current()
	target_pos = global_position

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				drag_enabled = true
				drag_start_pos = get_global_mouse_position()
			else:
				drag_enabled = false
	elif event is InputEventMouseMotion:
		if drag_enabled:
			var mouse_pos = get_global_mouse_position()
			var drag_vector = drag_start_pos - mouse_pos
			target_pos += drag_vector
			drag_start_pos = mouse_pos
			
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_UP):
		zoom *= 1 - C.ZOOM_STEP  # Zoom in
		print("Zoom: ", zoom)
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_DOWN):
		zoom *= 1 + C.ZOOM_STEP  # Zoom out
		print("Zoom: ", zoom)
		
	# Clamp the zoom value between min_zoom and max_zoom
	zoom.x = clamp(zoom.x, C.MIN_ZOOM, C.MAX_ZOOM)
	zoom.y = clamp(zoom.y, C.MIN_ZOOM, C.MAX_ZOOM)

func _process(delta):
	global_position = global_position.lerp(target_pos, 0.1)  # Smooth camera movement
