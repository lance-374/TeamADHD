extends Control


#@onready var play_button = $MarginContainer/HBoxContainer/VBoxContainer/play_button as Button
#@onready var option_button = $MarginContainer/HBoxContainer/VBoxContainer/option_button as Button
#@onready var quit_button = $MarginContainer/HBoxContainer/VBoxContainer/quit_button as Button
#@onready var start_level = preload("this file address")
@onready var audio_stream_player = $AudioStreamPlayer
#var fullscreen
# Called when the node enters the scene tree for the first time.
func _ready():
	audio_stream_player.play()
	#fullscreen = false
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("jump1"):
		get_tree().change_scene_to_file("res://Levels/level_lab.tscn")
	if Input.is_action_just_pressed("down1"):
		get_tree().change_scene_to_file("res://lore_1.tscn")
	#if Input.is_action_just_pressed("fullscreen"):
		#toggle_fullscreen()
#
#func toggle_fullscreen():
	#if fullscreen:
		#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		#fullscreen = false
	#else:
		#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		#fullscreen = true
#
func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Levels/level_lab.tscn")
	
func _on_option_button_pressed():
	get_tree().change_scene_to_file("res://lore_1.tscn")

func _on_quit_button_pressed():
	get_tree().change_scene_to_file("res://Levels/title_screen.tscn")
