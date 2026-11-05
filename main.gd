extends Node


@onready var ticker: Timer = $Timer
@onready var snake: Snake = $Snake
var size: Vector2i

func _ready() -> void:
	size = $Snake.grid_size * int($Snake.cell_size)
	var window = get_window()
	window.size = size
	window.content_scale_size = size
	ticker.timeout.connect(snake.tick)
