extends Node2D
@onready var player_1 = $Player1
@onready var player_2 = $Player2
var fullscreen
# Called when the node enters the scene tree for the first time.
func _ready():
	$MultiTargetCamera2D.add_target(player_1)
	$MultiTargetCamera2D.add_target(player_2)
	fullscreen = false
	#var r = $TileMap.get_used_rect()
	$MultiTargetCamera2D.limit_left = -416 #r.position.x * $TileMap.tile_set.tile_size.x
	$MultiTargetCamera2D.limit_right = 672 #r.end.x * $TileMap.tile_set.tile_size.x
	$MultiTargetCamera2D.limit_bottom = 160 #r.end.y * $TileMap.tile_set.tile_size.y
	#$MultiTargetCamera2D.limit_top = -320 #r.position.y * $TileMap.tile_set.tile_size.y
	
func _process(_delta):
	if Input.is_action_just_pressed("fullscreen"):
		toggle_fullscreen()

func toggle_fullscreen():
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		fullscreen = false
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		fullscreen = true
