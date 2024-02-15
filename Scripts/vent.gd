extends StaticBody2D

@export var health = 20

func update_health(h):
	health = h
	if health <= 0:
		queue_free()
