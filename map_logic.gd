extends Node

@export var tilemap: TileMapLayer
var tileset: TileSet
var cell_size: Vector2i

func get_custom_data(custom_data_name: String, tile: Vector2i) -> Variant:
	var data = tilemap.get_cell_tile_data(tile)
	var custom_data: Variant = data.get_custom_data(custom_data_name)
	
	return custom_data
	
func _ready() -> void:
	tileset = tilemap.tile_set	
	cell_size = tileset.tile_size
	
func get_tile_size() -> Vector2i:
	cell_size = tileset.tile_size
	return cell_size

func get_cell_data(cell_position: Vector2i):
	var id = tilemap.get_cell_source_id(cell_position)
	var atlas_coords = tilemap.get_cell_atlas_coords(cell_position)
	var alt = tilemap.get_cell_alternative_tile(cell_position)
	return [cell_position, id, atlas_coords, alt]

func set_cell(cell_data: Array):
	tilemap.set_cell(cell_data[0], cell_data[1], cell_data[2], cell_data[3])

func get_tile_map_data():
	var used = tilemap.get_used_cells()
	var map_data = []
	for cell in used:
		map_data.append(get_cell_data(cell))
	return map_data

func get_map_dimensions() -> Vector2i:
	var rect: Vector2i  = tilemap.get_used_rect().size
	return rect
	
func get_cells_type(atlas_coords: Vector2i) -> Array[Vector2i]:
	return tilemap.get_used_cells_by_id(0, atlas_coords, 0)
	
func update_occupied(cell: Vector2i) -> void:
	var cell_data = get_cell_data(cell)
	if cell_data[2] == Vector2i(0,0):
		set_cell([cell_data[0], cell_data[1],Vector2i(2, 1), cell_data[3]])
	else:
		set_cell([cell_data[0], cell_data[1],Vector2i(0, 0), cell_data[3]])
