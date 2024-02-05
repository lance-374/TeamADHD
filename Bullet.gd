extends Area2D

@export var speed = Vector2(750, 0)

@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D


var facing_left = false

func _physics_process(delta):
	position += transform.x * speed.x * delta
	position += transform.y * speed.y * delta
	#if speed != Vector2.ZERO:
		#look_at(global_position + speed)

func set_speed(direction):
	var angle = rad_to_deg(atan2(direction.x, 0-direction.y))-90
	speed = direction.normalized() * 750
	if speed.x < 0:
		facing_left = true
	if speed.x > 0:
		facing_left = false
	rotation_degrees = angle
	#print(angle)
	sprite_2d.rotation_degrees = angle
	collision_shape_2d.rotation_degrees = angle

func _on_body_entered(body):
	if body.is_in_group('players'):
		body.queue_free()
		$/root/Level_1/MultiTargetCamera2D.remove_target(body)
		#get_tree().quit(0)
	queue_free()
