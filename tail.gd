extends CharacterBody2D


@export var tail_speed: int = 2
@export var tail_distance: int = 32
@export var margin: int = 2
@export var max: int = 160
var square_size: int
var speed: int

var parent: CharacterBody2D

func _ready() -> void:
	speed = parent.speed
	square_size = parent.square_size
	start()

func _physics_process(delta: float) -> void:
	var x_diff = int(abs(position.x)) % parent.square_size
	var y_diff = int(abs(position.y)) % parent.square_size
	
	
	if x_diff <= margin and y_diff <= margin:
		tail_move()
		print("tail")
	var collision = move_and_collide(velocity * delta)
	
	
func tail_move():
	var diff = parent.position - position
	velocity = diff.normalized() * tail_speed * parent.speed
	if velocity.length() < parent.speed:
		velocity = velocity.normalized() * parent.speed
	print(diff)
	print(velocity)
		
func start():
	position = parent.position - Vector2(0, - tail_distance)
	tail_move()
	
