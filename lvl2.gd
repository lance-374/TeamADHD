extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$MultiTargetCamera2D.add_target($Player1)
	$MultiTargetCamera2D.add_target($Player2)
	
	var r = $TileMap.get_used_rect()
	$MultiTargetCamera2D.limit_left = r.position.x * $TileMap.tile_set.tile_size.x
	$MultiTargetCamera2D.limit_right = r.end.x * $TileMap.tile_set.tile_size.x
	$MultiTargetCamera2D.limit_bottom = r.end.y * $TileMap.tile_set.tile_size.y
	$MultiTargetCamera2D.limit_top = r.position.y * $TileMap.tile_set.tile_size.y
