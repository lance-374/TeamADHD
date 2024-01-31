extends Area2D

@export var speed = Vector2(750, 0)

@onready var sprite_2d = $Sprite2D

var facing_left = false

func _physics_process(delta):
	position += transform.x * speed.x * delta
	position += transform.y * speed.y * delta
	#look_at(speed)

func _on_Bullet_body_entered(body):
	if body == 'player2':
		body.queue_free()
	queue_free()
	
func set_speed(direction):
	speed.x = direction.x * 750
	speed.y = direction.y * 750
	if speed.x < 0:
		facing_left = false
	if speed.x > 0:
		facing_left = true
	sprite_2d.flip_h = facing_left
