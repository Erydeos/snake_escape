extends Node


@onready var ticker: Timer = $Timer
@onready var snake: Snake = $Snake

var size: Vector2i
var alive: bool = false

func _ready() -> void:
	var cell_size = $Map.cell_size
	var cell_dimensions = $Map.get_map_dimensions()
	$Snake.grid_size = cell_dimensions
	$Snake.cell_size = cell_size.x
	size = cell_dimensions * cell_size
	var window = get_window()
	window.size = size
	window.content_scale_size = size
	ticker.timeout.connect(tick)
	snake.init()

	start()


func add_food(num: int) -> void:
	var f1: Array = $Map.get_cells_type(Vector2i(2, 1))
	var f2 = $Map.get_cells_type(Vector2i(2, 2))
	var f3 = $Map.get_cells_type(Vector2i(3, 1))
	var f4 = $Map.get_cells_type(Vector2i(3, 2))
	f1.append_array(f2)
	f1.append_array(f3)
	f1.append_array(f4)
	for i in num:
		var data = $Map.get_cell_data(f1.pick_random())
		data[2] = Vector2i(1,0)
		$Map.set_cell(data)

func tick() -> void:
	if alive:
		snake.tick()
		check_snake()
	elif snake.get_sprites() != []:
		snake.destroy()
	else:
		game_over()
		
	
	
func check_snake() -> void:
	var snake_segments = snake.get_body()
	for cell in snake_segments:
		if $Map.get_custom_data("Deadly", cell):
			alive = false
			return
		var grow = $Map.get_custom_data("Growth", cell)
		if grow > 0:
			snake.body.grow(grow)
			var cell_data = $Map.get_cell_data(cell)
			cell_data[2] = Vector2i(2, 1)
			$Map.set_cell(cell_data)

func game_over():
	print("Game Over")
	snake.death()
	$Timer.stop() 
	
func start() -> void:
	$Snake.spawn_body()
	alive = true
	add_food(3)
	$Timer.autostart = true
	$Timer.start()
	
