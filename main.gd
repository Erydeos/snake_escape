extends Node


@onready var ticker: Timer = $Timer
@onready var snake: Snake = $Snake
@onready var hud: CanvasLayer = $HUD
@export var window_margin: int = 0


var size: Vector2i
var alive: bool = false
var score: float = 0
var paused: bool = false

func _ready() -> void:
	var cell_size = $Map.cell_size
	var cell_dimensions = $Map.get_map_dimensions()
	snake.grid_size = cell_dimensions
	snake.cell_size = cell_size.x
	size = cell_dimensions * cell_size
	size.y = size.y + window_margin
	var window = get_window()
	window.size = size
	window.content_scale_size = size
	
	ticker.timeout.connect(tick)
	
	snake.init()
	snake.snake_update.connect(update_snake_collision)

	hud.update_score.connect(update_score)
	hud.scale_hud(size)
	hud.print_message("Grow and Escape")


func add_food(num: int) -> void:
	var f1: Array = $Map.get_cells_type(Vector2i(2, 1))
	var f2 = $Map.get_cells_type(Vector2i(2, 2))
	var f3 = $Map.get_cells_type(Vector2i(3, 1))
	var f4 = $Map.get_cells_type(Vector2i(3, 2))
	f1.append_array(f2)
	f1.append_array(f3)
	f1.append_array(f4)
	seed(1)
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
	var cell = snake_segments[0]
	if $Map.get_custom_data("Deadly", cell):
		alive = false
		return
	elif $Map.get_custom_data("Win", cell):
		win()
	var grow = $Map.get_custom_data("Growth", cell)
	if grow > 0:
		snake.body.grow(grow)
		reset_tile(cell)

func game_over():
	hud.print_message("Game Over")
	snake.death()
	ticker.stop()
	$FoodTimer.stop()
	hud.toggle_visibility() 
	
func start() -> void:
	snake.clear()
	snake.death()
	reset()
	score = 0
	var snake_segements: Array[Vector2i] = snake.spawn_body()
	update_snake_collision(snake_segements.slice(1, snake_segements.size()))
	alive = true
	add_food(3)
	ticker.start()
	ticker.autostart = true
	$FoodTimer.start()
	$FoodTimer.autostart = true
	paused = false

func _on_hud_start_signal() -> void:
	start()
	if paused:
		hud.pause()
	else:
		hud.toggle_visibility()

func win():
	snake.death()
	ticker.stop()
	$FoodTimer.stop()
	hud.toggle_visibility() 
	hud.print_message("Escaped!\n Score: " + str(score))
	
func reset() -> void:
	var cells: Array = $Map.get_cells_type(Vector2i(1, 0))
	cells.append_array($Map.get_cells_type(Vector2i(0,0)))
	for cell in cells:
		reset_tile(cell)

func reset_tile(cell: Vector2i) -> void:
	var cell_data = $Map.get_cell_data(cell)
	cell_data[2] = Vector2i(2, 1)
	$Map.set_cell(cell_data)

func update_snake_collision(segments: Array):
	for segment in segments:
		$Map.update_occupied(segment)

func update_score(time: float, time_step: float) -> void:
	var score_ar: Array = calculate_score(time_step)
	score = snappedf(score + score_ar[0], 0.1)
	hud.print_score(score_ar[1], score)
	
func calculate_score(time_step: float) -> Array:
	var score: float
	var length: int = snake.get_body().size()
	score = length * time_step
	var score_string = "Snake Length: " +str(length) + " -> " + str(score) + "/s"
	return [score, score_string]


func _on_food_timer_timeout() -> void:
	add_food(1)
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"): 
		toggle_pause.call_deferred()
		
func toggle_pause() -> void:
	if not paused:
		if ticker.is_stopped():
			return
		ticker.stop()
		$FoodTimer.stop()
		hud.pause(paused)
		paused = true

	else:
		ticker.start()
		$FoodTimer.start()
		hud.pause(paused)
		paused = false
