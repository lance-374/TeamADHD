extends StaticBody2D

var is_playing = false
var rng = RandomNumberGenerator.new()
var player = "0"
var powerup_id = -1
@onready var jukebox_player = $JukeboxPlayer
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var level_music_player = $LevelMusicPlayer
@onready var player_1 = $"../Player1"
@onready var player_2 = $"../Player2"

var tracklist = [preload("res://Sounds/Jukebox2.0/Careless Whisper.mp3"), preload("res://Sounds/Jukebox2.0/Elevator.mp3"), preload("res://Sounds/Jukebox2.0/Jazz.mp3"), preload("res://Sounds/Jukebox2.0/Lightbringer-Metal.mp3"), preload("res://Sounds/Jukebox2.0/The Four Seasons-Classical.mp3"), preload("res://Sounds/Jukebox2.0/Rickroll.mp3")]
func _ready():
	level_music_player.play()
	jukebox_player.play()
	animated_sprite_2d.play("off")

func activate(p, powerup = rng.randi_range(0,5)):
	if not is_playing:
		is_playing = true
		player = p
		level_music_player.stop()
		powerup_id = powerup
		jukebox_player.stream = tracklist[powerup_id]
		if powerup_id == 5: #rickroll
			if player == "1":
				player = "2"
			else:
				player = "1"
			print("Rickrolled player " + player)
			powerup_id = rng.randi_range(0,4)
		if powerup_id == 0: #moonwalk
			if player == "1":
				player_2.moonwalk = true
			else:
				player_1.moonwalk = true
			print("Triggered moonwalk for player " + player)
		elif powerup_id == 1: #flip gravity
			if player == "1":
				player_2.reverse_gravity()
			else:
				player_1.reverse_gravity()
			print("Flipped gravity for player " + player)
		elif powerup_id == 2: #increase recharge speed
			if player == "1":
				player_1.recharge *= 2
			else:
				player_2.recharge *= 2
			print("Increased recharge on player " + player)
		elif powerup_id == 3: #machine gun
			if player == "1":
				player_1.machine_gun = true
			else:
				player_2.machine_gun = true
			print("Triggered machine gun on player " + player)
		elif powerup_id == 4: #vampirism
			if player == "1":
				player_1.vampirism = true
			else:
				player_2.vampirism = true
			print("Triggered vampirism on player " + player)
		jukebox_player.play()
		animated_sprite_2d.play("on")

func _on_jukebox_player_finished():
	is_playing = false
	animated_sprite_2d.play("off")
	if powerup_id == 0: #moonwalk
		if player == "1":
			player_2.moonwalk = false
		else:
			player_1.moonwalk = false
	elif powerup_id == 1: #flip gravity
		if player == "1":
			player_2.reverse_gravity()
		else:
			player_1.reverse_gravity()
	elif powerup_id == 2: #increase cooldown
		if player == "1":
			player_1.recharge /= 2
		else:
			player_2.recharge /= 2
	elif powerup_id == 3: #flip gravity
		if player == "1":
			player_2.gravity_flipped = not player_2.gravity_flipped
		else:
			player_1.gravity_flipped = not player_1.gravity_flipped
	elif powerup_id == 3: #machine gun
		if player == "1":
			player_1.machine_gun = false
		else:
			player_2.machine_gun = false
	elif powerup_id == 4: #vampirism
		if player == "1":
			player_1.vampirism = false
		else:
			player_2.vampirism = false
	player = "0"
	powerup_id = -1
	level_music_player.play()
	
