extends CharacterBody2D

signal out_of_bounds

@export var speed: int = 160
@export var margin: int = 2
@export var squares: int = 16
var screen_size: Vector2
var square_size: int
enum State {UP, DOWN, LEFT, RIGHT}
var state: State = State.UP
var n: int

func _ready() -> void:
	screen_size = get_viewport_rect().size
	@warning_ignore("integer_division")
	square_size = screen_size.x / squares
	start()

func _physics_process(delta: float) -> void:
	var x_diff = int(abs(position.x)) % square_size
	var y_diff = int(abs(position.y)) % square_size
	
	
	if x_diff <= margin and y_diff <= margin:
		#print("grid, x: {x_diff}, y: {y_diff}, n:{n}".format({"x_diff"=x_diff, "y_diff"=y_diff, "n"=n}))
		n +=1
		manage_input()
		state_machine()
		velocity = Vector2.UP.rotated(rotation).normalized() * speed
	var collision = move_and_collide(velocity * delta)

func manage_input():
	if Input.is_physical_key_pressed(KEY_W):
		state = State.UP
	if Input.is_physical_key_pressed(KEY_S):
		state = State.DOWN
	if Input.is_physical_key_pressed(KEY_D):
		state = State.RIGHT
	if Input.is_physical_key_pressed(KEY_A):
		state = State.LEFT

func state_machine():
	match state:
		State.UP:
			rotation = 0
		State.DOWN:
			rotation = PI
		State.RIGHT:
			rotation = PI/2
		State.LEFT:
			rotation = -PI/2

func start():
	velocity = Vector2.UP * speed
	position = Vector2(square_size*squares/2, square_size*squares/2)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	out_of_bounds.emit()
