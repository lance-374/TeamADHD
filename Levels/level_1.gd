extends Node2D
@onready var player_1 = $Player1
@onready var player_2 = $Player2

# Called when the node enters the scene tree for the first time.
func _ready():
	$MultiTargetCamera2D.add_target(player_1)
	$MultiTargetCamera2D.add_target(player_2)
	
	#var r = $TileMap.get_used_rect()
	$MultiTargetCamera2D.limit_left = -416 #r.position.x * $TileMap.tile_set.tile_size.x
	$MultiTargetCamera2D.limit_right = 672 #r.end.x * $TileMap.tile_set.tile_size.x
	$MultiTargetCamera2D.limit_bottom = 160 #r.end.y * $TileMap.tile_set.tile_size.y
	#$MultiTargetCamera2D.limit_top = -320 #r.position.y * $TileMap.tile_set.tile_size.y
