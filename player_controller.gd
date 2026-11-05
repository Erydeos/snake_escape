class_name PlayerController
extends SnakeController

@export var max_buffer: int = 2

var _queue: Array[Vector2i] = []
var _current: Vector2i = Vector2i.ZERO

func _unhandled_input(event: InputEvent) -> void:
	var dir: Vector2i = Vector2i.ZERO
	if event.is_action_pressed("move_up"): dir = Vector2i.UP
	elif event.is_action_pressed("move_down"): dir = Vector2i.DOWN
	elif event.is_action_pressed("move_right"): dir = Vector2i.RIGHT
	elif event.is_action_pressed("move_left"):  dir = Vector2i.LEFT
	
	if dir == Vector2i.ZERO or _queue.size() >= max_buffer:
		return
	
	var reference = _queue.back() if not _queue.is_empty() else _current
	if dir == reference or dir == -reference:
		return
	_queue.push_back(dir)
	

func next_direction(current: Vector2i) -> Vector2i:
	_current = current
	if _queue.is_empty():
		return current
	else:
		return _queue.pop_front()
		
		
