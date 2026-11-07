class_name Snake_body_logic
extends RefCounted

signal head_added(cell: Vector2i)
signal tail_removed(cell: Vector2i)
signal grew(amount: int)
signal old_head(segment: Vector2i)

var segments: Array[Vector2i] = []
var direction: Vector2i  
var _pending_growth: int 


func step() -> void:
	var new_head: Vector2i = segments[0] + direction
	old_head.emit(segments[0])
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

func clear() -> void:
	segments = []

func respawn(start_p: Vector2i, start_l: int) -> void:
	for i in start_l:
		segments.append(start_p - Vector2i(i, 0))
	direction = Vector2i.RIGHT
	_pending_growth = 0 

	
