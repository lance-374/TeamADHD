extends Area2D

var speed = Vector2(0, 0)
@onready var bullet_sound = $BulletSound
@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D
var damage = 2
var player = 0

var facing_left = false
var entered_body = false
var vampirism = false
var player_object

func _ready():
	bullet_sound.play()

func _physics_process(delta):
	position += transform.x * speed.x * delta
	position += transform.y * speed.y * delta
	if entered_body and not bullet_sound.is_playing():
		queue_free()
	

func set_speed(direction):
	var angle = rad_to_deg(atan2(direction.x, 0-direction.y))-90
	speed = direction.normalized() * 750
	if speed.x < 0:
		facing_left = true
	if speed.x > 0:
		facing_left = false
	rotation_degrees = angle
	sprite_2d.rotation_degrees = angle
	collision_shape_2d.rotation_degrees = angle

func set_player(p, object, v=false):
	player = p
	vampirism = v
	player_object = object

func _on_body_entered(body):
	if body.is_in_group("players"):
		body.subtract_health(damage)
		if vampirism:
			player_object.update_health(player_object.health + damage)
	elif body.is_in_group("gravity"):
		body.update_health(body.health - damage)
	elif body.is_in_group("vents"):
		body.update_health(body.health - damage)
	elif body.is_in_group("jukebox"):
		body.activate(player)
	set_speed(Vector2.ZERO)
	hide()
	collision_shape_2d.queue_free()
	entered_body = true
