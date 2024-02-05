extends Node2D

@onready var polygon_2d = $StaticBody2D/CollisionPolygon2D/Polygon2D
@onready var collision_polygon_2d = $StaticBody2D/CollisionPolygon2D



func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)
	polygon_2d.polygon = collision_polygon_2d.polygon
	#$MultiTargetCamera2D.add_target($Player1)
	#$MultiTargetCamera2D.add_target($Player2)
	#
	#$MultiTargetCamera2D.limit_left = 0 #r.position.x * $TileMap.tile_set.tile_size.x
	#$MultiTargetCamera2D.limit_right = 336 #r.end.x * $TileMap.tile_set.tile_size.x
	#$MultiTargetCamera2D.limit_bottom = 184 #r.end.y * $TileMap.tile_set.tile_size.y
	#$MultiTargetCamera2D.limit_top = 0 #r.position.y * $TileMap.tile_set.tile_size.y
