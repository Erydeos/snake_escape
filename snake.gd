class_name Snake
extends Node

var body: Snake_body_logic

@onready var controller: SnakeController = $Controller
@onready var view = $View
@export var start_cell: Vector2i
@export var start_length: int = 3
@export var cell_size: int = 32
@export var input_queue: int = 5
@export var grid_size: Vector2i = Vector2i(20, 20)


func _ready() -> void:
	$Controller.max_buffer = input_queue
	view.cell_size = cell_size
	

func tick() -> void:
	body.direction = controller.next_direction(body.direction)
	body.step()

func spawn_body():
	start_cell = grid_size / 2
	body = Snake_body_logic.new(start_cell, start_length)
	view.bind(body)
