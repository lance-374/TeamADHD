extends StaticBody2D

var is_playing
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	is_playing = true
	audio_stream_player_2d.play()
	animated_sprite_2d.play("on")

func toggle():
	if is_playing:
		is_playing = false
		audio_stream_player_2d.stop()
		animated_sprite_2d.play("off")
	else:
		is_playing = true
		audio_stream_player_2d.play()
		animated_sprite_2d.play("on")
