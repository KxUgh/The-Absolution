extends TileMapLayer

var all_layers: Array[TileMapLayer]
var higher_layers: Array[TileMapLayer]

func _ready() -> void:
	var siblings: Array[Node] = get_parent().get_children()
	for sibling in siblings:
		if sibling is TileMapLayer:
			all_layers.append(sibling)
	higher_layers = all_layers.slice(all_layers.find(self)+1)
	

func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	for other_layer in higher_layers:
		if not other_layer.enabled:
			return false
		if coords in other_layer.get_used_cells():
			var tile_data = other_layer.get_cell_tile_data(coords)
			if tile_data != null:
				# Produces runtime errors because not all tilesets
				# have defined collision layers (I wonder why)
				if tile_data.get_collision_polygons_count(0) > 0:
					return true
	return false

func _tile_data_runtime_update(_coords: Vector2i, tile_data: TileData) -> void:
	tile_data.set_navigation_polygon(0,null)
