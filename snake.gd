class_name Snake
extends Node

signal snake_update(segment: Array[Vector2i])

var body: Snake_body_logic

@onready var controller: SnakeController = $Controller
@onready var view = $View
@export var start_cell: Vector2i
@export var start_length: int = 3
@export var cell_size: int = 32
@export var input_queue: int = 2
@export var grid_size: Vector2i = Vector2i(20, 20)



func _ready() -> void:
	$Controller.max_buffer = input_queue
	view.cell_size = cell_size
	

func tick() -> void:
	body.direction = controller.next_direction(body.direction)
	body.step()
	

func spawn_body() -> Array[Vector2i]:
	$Controller.clear()
	view.clear_sprites()
	body.respawn(start_cell, start_length)
	view.bind(body)
	return body.segments
	

func get_body() -> Array[Vector2i]:
	return body.segments

func death() ->void:
	body.clear()
	

func init() ->void:
	start_cell = grid_size / 2
	body = Snake_body_logic.new()
	body.old_head.connect(snake_move)
	body.tail_removed.connect(snake_move)

func destroy() -> void:
	view.play_death()

func get_sprites() -> Array:
	return view._sprites

func snake_move(segment: Vector2i):
	var segment_ar = [segment]
	snake_update.emit(segment_ar)
