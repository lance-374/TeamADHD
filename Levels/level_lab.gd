extends Node2D
@onready var player_1 = $Player1
@onready var player_2 = $Player2
@onready var tile_map = $TileMap
@onready var multi_target_camera_2d = $MultiTargetCamera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	multi_target_camera_2d.add_target(player_1)
	multi_target_camera_2d.add_target(player_2)
	var r = tile_map.get_used_rect()
	multi_target_camera_2d.limit_left= r.position.x * tile_map.tile_set.tile_size.x
	multi_target_camera_2d.limit_right = r.end.x * tile_map.tile_set.tile_size.x
	multi_target_camera_2d.limit_bottom = r.end.y * tile_map.tile_set.tile_size.y
	multi_target_camera_2d.limit_top = -1000#r.position.y * tile_map.tile_set.tile_size.y
