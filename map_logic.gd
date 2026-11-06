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

func set_cell(position: Vector2i, id: int, atlas_coords: Vector2i, alt: int):
	tilemap.set_cell(Vector2i(5,5), 0, Vector2i(2, 0), 0)

func get_tile_map_data():
	var used = tilemap.get_used_cells()
	var map_data = []
	for cell in used:
		map_data.append(get_cell_data(cell))
	return map_data

func get_map_dimensions() -> Vector2i:
	var rect: Vector2i  = tilemap.get_used_rect().size
	return rect
	
