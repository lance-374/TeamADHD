extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -300.0
const FRICTION = 1000
const ACCEL = 600

#var controller_index = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var muzzle = $Muzzle
var Bullet = preload("res://bullet.tscn") # Will load when parsing the script.
var isFlipped = false

func _physics_process(delta):
	apply_gravity(delta)
	handle_jump()
	var input_axis = Input.get_axis("left1", "right1")
	if input_axis < 0:
		isFlipped = true
	if input_axis > 0:
		isFlipped = false
	handle_shoot()
	apply_accel(input_axis, delta)
	apply_friction(input_axis, delta)
	update_animation(input_axis)
	move_and_slide()
	
func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

var jump = 'jump1'
func handle_jump():
	if is_on_floor() and Input.is_action_just_pressed(jump):
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_released(jump) and velocity.y < JUMP_VELOCITY / 2:
		velocity.y = JUMP_VELOCITY / 2

func handle_shoot():
	if Input.is_action_just_pressed("shoot1"):
		var b = Bullet.instantiate()
		get_tree().root.add_child(b)
		if isFlipped:
			muzzle.position.x = 8
			b.set_speed(-750)
		else:
			muzzle.position.x = -8
			b.set_speed(750)
		b.transform = $Muzzle.global_transform

func apply_friction(input_axis, delta):
	if input_axis == 0:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

func apply_accel(input_axis, delta):
	if input_axis:
		velocity.x = move_toward(velocity.x, SPEED * input_axis, ACCEL * delta)

func update_animation(input_axis):
	if input_axis != 0:
		animated_sprite_2d.flip_h = input_axis < 0
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
	
	if not is_on_floor():
		animated_sprite_2d.play("jump")

#HEALTH BAR
@onready var healthbar = $Hpbar



func _ready():
	var health = 100
	healthbar.init_health(health)
	
#func _set_health(value):
#	super._set_health(value)
#	healthbar.health = health
	
#func _on_hurtbox_area_entered(area):
#	health -= 1
#	got_hit_anim_player.play("got_hit")
