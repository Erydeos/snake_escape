class_name SnakeView
extends Node2D

@export var skin: SnakeSkin
@export var cell_size: int = 32

var _sprites: Array[Sprite2D] = []
var _pool: Array[Sprite2D] = []
var inset: int = 2
var first: bool = true

func bind(body: Snake_body_logic) -> void:
	for i in range(body.segments.size() - 1, -1, -1):
		_push_head(body.segments[i])
	if first:
		body.head_added.connect(_push_head)
		body.tail_removed.connect(_pop_tail)
		first = false


func _push_head(cell: Vector2i) -> void:
	if not _sprites.is_empty():
		_appy_texture(_sprites[0], skin.tail_texture)

	var sprite: Sprite2D = _get_sprite()
	_appy_texture(sprite, skin.head_texture)
	sprite.position = grid_to_world(cell) + Vector2.ONE * inset
	_sprites.push_front(sprite)

func _get_sprite() -> Sprite2D:
	var sprite: Sprite2D
	if _pool.is_empty():
		sprite = Sprite2D.new()
		sprite.centered = false
		add_child(sprite)
	else:
		sprite = _pool.pop_back()
	sprite.modulate = skin.tint
	sprite.show()
	return sprite

func _pop_tail(cell: Vector2i) -> void:
	_release(_sprites.pop_back())

func grid_to_world(cell: Vector2i) -> Vector2:
	return cell * cell_size

func _release(sprite: Sprite2D) -> void:
	sprite.hide()
	_pool.push_back(sprite)

func play_death() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.RED, 0.1)
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)
	_release(_sprites.pop_back())

func _appy_texture(sprite: Sprite2D, tex: Texture2D) -> void:
	sprite.texture = tex
	sprite.scale = Vector2(cell_size - inset*2, cell_size - inset*2) / tex.get_size()

func clear_sprites() -> void:
	for i in range(_sprites.size()):
		_release(_sprites.pop_back())
