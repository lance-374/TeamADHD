extends StaticBody2D

@export var health = 20
@onready var player_1 = $"../Player1"
@onready var player_2 = $"../Player2"

func update_health(h):
	health = h
	if health <= 0:
		player_1.reverse_gravity()
		player_2.reverse_gravity()
		health = 20
