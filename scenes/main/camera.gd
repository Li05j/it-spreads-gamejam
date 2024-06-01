extends Camera2D

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

func _process(delta):
	global_position = target_pos # TODO: fix scuffed camera movements

