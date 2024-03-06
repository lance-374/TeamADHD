extends StaticBody2D

var is_playing
var rng = RandomNumberGenerator.new()
@onready var jukebox_player = $JukeboxPlayer
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var level_music_player = $LevelMusicPlayer

var tracklist = [preload("res://Sounds/Jukebox/careless.mp3"), preload("res://Sounds/Jukebox/elevator.mp3"), preload("res://Sounds/Jukebox/four_seasons.mp3"), preload("res://Sounds/Jukebox/jazz.mp3"), preload("res://Sounds/Jukebox/lightbringer.mp3"), preload("res://Sounds/Jukebox/rickroll.mp3")]
func _ready():
	is_playing = true
	level_music_player.play()
	jukebox_player.play()
	animated_sprite_2d.play("off")

func toggle():
	if is_playing: #turn off
		is_playing = false
		jukebox_player.stop()
		level_music_player.play()
		animated_sprite_2d.play("off")
	else: #turn on
		is_playing = true
		level_music_player.stop()
		jukebox_player.stream = tracklist[rng.randi_range(0,5)]
		jukebox_player.play()
		animated_sprite_2d.play("on")
