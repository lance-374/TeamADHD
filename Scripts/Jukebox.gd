extends StaticBody2D

var is_playing
var rng = RandomNumberGenerator.new()
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var animated_sprite_2d = $AnimatedSprite2D
var tracklist = [preload("res://Sounds/Jukebox/careless.mp3"), preload("res://Sounds/Jukebox/elevator.mp3"), preload("res://Sounds/Jukebox/four_seasons.mp3"), preload("res://Sounds/Jukebox/jazz.mp3"), preload("res://Sounds/Jukebox/lightbringer.mp3"), preload("res://Sounds/Jukebox/rickroll.mp3"), preload("res://Sounds/Jukebox/smellsbad.mp3")]
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
		audio_stream_player_2d.stream = tracklist[rng.randi_range(0,6)]
		audio_stream_player_2d.play()
		animated_sprite_2d.play("on")
