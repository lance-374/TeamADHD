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

var tracklist = [preload("res://Sounds/8-bit music/careless_whisper.mp3"), preload("res://Sounds/8-bit music/elevator.mp3"), preload("res://Sounds/8-bit music/four_seasons.mp3"), preload("res://Sounds/8-bit music/lightbringer.mp3"), preload("res://Sounds/8-bit music/four_seasons.mp3"), preload("res://Sounds/8-bit music/rickroll.mp3")]

func _ready():
	level_music_player.play()
	jukebox_player.play()
	animated_sprite_2d.play("off")

func _process(_delta):
	if Input.is_action_just_pressed("1"):
		activate("1", 0)
	if Input.is_action_just_pressed("2"):
		activate("1", 1)
	if Input.is_action_just_pressed("3"):
		activate("1", 2)
	if Input.is_action_just_pressed("4"):
		activate("1", 3)
	if Input.is_action_just_pressed("5"):
		activate("1", 4)
	if Input.is_action_just_pressed("6"):
		activate("1", 5)

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
			#print("Rickrolled player " + player)
			powerup_id = rng.randi_range(0,4)
		if powerup_id == 0: #moonwalk
			if player == "1":
				player_2.moonwalk = true
			else:
				player_1.moonwalk = true
			#print("Triggered moonwalk for player " + player)
		elif powerup_id == 1: #flip gravity
			if player == "1":
				player_2.reverse_gravity()
			else:
				player_1.reverse_gravity()
			#print("Flipped gravity for player " + player)
		elif powerup_id == 2: #increase recharge speed
			if player == "1":
				player_1.recharge *= 2
			else:
				player_2.recharge *= 2
			#print("Increased recharge on player " + player)
		elif powerup_id == 3: #machine gun
			if player == "1":
				player_1.toggle_machine_gun()
			else:
				player_2.toggle_machine_gun()
			#print("Triggered machine gun on player " + player)
		elif powerup_id == 4: #vampirism
			if player == "1":
				player_1.vampirism = true
			else:
				player_2.vampirism = true
			#print("Triggered vampirism on player " + player)
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
	elif powerup_id == 3: #machine gun
		if player == "1":
			player_1.toggle_machine_gun()
		else:
			player_2.toggle_machine_gun()
	elif powerup_id == 4: #vampirism
		if player == "1":
			player_1.vampirism = false
		else:
			player_2.vampirism = false
	player = "0"
	powerup_id = -1
	level_music_player.play()
	
