class_name Snake_body_logic
extends RefCounted

signal head_added(cell: Vector2i)
signal tail_removed(cell: Vector2i)
signal grew(amount: int)

var segments: Array[Vector2i] = []
var direction: Vector2i = Vector2i.RIGHT
var _pending_growth: int = 0

func _init(start_position: Vector2i, start_length: int) -> void:
	for i in start_length:
		segments.append(start_position - Vector2i(i, 0))

func step() -> void:
	var new_head: Vector2i = segments[0] + direction
	segments.push_front(new_head)
	head_added.emit(new_head)
	if _pending_growth > 0:
		_pending_growth -= 1
	else:
		tail_removed.emit(segments.pop_back())

func grow(amount: int):
	_pending_growth += amount
	grew.emit(amount)

func is_in_cell(cell: Vector2i):
	return cell in segments
