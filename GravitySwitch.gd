extends StaticBody2D

@export var health = 20
@onready var player_1 = $"../Player1"
@onready var player_2 = $"../Player2"
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

func update_health(h):
	health = h
	if health <= 0:
		player_1.reverse_gravity()
		player_2.reverse_gravity()
		audio_stream_player_2d.play()
		if player_1.gravity > 0:
			animated_sprite_2d.play("off")
		else:
			animated_sprite_2d.play("on")
		health = 20
