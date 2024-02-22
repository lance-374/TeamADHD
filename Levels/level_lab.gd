extends Node2D
@onready var player_1 = $Player1
@onready var player_2 = $Player2

# Called when the node enters the scene tree for the first time.
func _ready():
	$MultiTargetCamera2D.add_target(player_1)
	$MultiTargetCamera2D.add_target(player_2)
	var r = $"background layer".get_used_rect()
	$MultiTargetCamera2D.limit_left= r.position.x * $"background layer".tile_set.tile_size.x
	$MultiTargetCamera2D.limit_right = r.end.x * $"background layer".tile_set.tile_size.x
	$MultiTargetCamera2D.limit_bottom = r.end.y * $"background layer".tile_set.tile_size.y
	#$MultiTargetCamera2D.limit_top = -320 #r.position.y * $TileMap.tile_set.tile_size.y
