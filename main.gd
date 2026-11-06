extends Node


@onready var ticker: Timer = $Timer
@onready var snake: Snake = $Snake

var size: Vector2i

func _ready() -> void:
	var cell_size = $Map.cell_size
	var cell_dimensions = $Map.get_map_dimensions()
	$Snake.grid_size = cell_dimensions
	$Snake.cell_size = cell_size.x
	size = cell_dimensions * cell_size
	var window = get_window()
	window.size = size
	window.content_scale_size = size
	
	$Snake.spawn_body()
	ticker.timeout.connect(snake.tick)
