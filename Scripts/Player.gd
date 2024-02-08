extends CharacterBody2D

const SPEED = 100.0*2
const FRICTION = 1000*2
const ACCEL = 600*2

var aim_input = Vector2.ZERO
@export var controller_id = "0"
@export var jump_velocity = -300.0*2
var health = 100

# Get the gravity from the project settings to be synced with RigidBody nodes.
@export var gravity = 980*2

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var muzzle = $Muzzle
@onready var Bullet = preload("res://Objects/bullet.tscn") # Will load when parsing the script.
var facing_left = false



func _physics_process(delta):
	if self == null:
		return
	apply_gravity(delta)
	handle_jump()
	var input_axis = Input.get_axis("left" + controller_id, "right" + controller_id)
	if input_axis < 0:
		facing_left = true
	if input_axis > 0:
		facing_left = false
	aim_input.x = Input.get_action_strength("rs_right" + controller_id) - Input.get_action_strength("rs_left" + controller_id)
	aim_input.y = Input.get_action_strength("rs_down" + controller_id) - Input.get_action_strength("rs_up" + controller_id)
	if aim_input.x < 0:
		facing_left = true
	if aim_input.x > 0:
		facing_left = false
	handle_shoot()
	apply_accel(input_axis, delta)
	apply_friction(input_axis, delta)
	update_animation(input_axis)
	move_and_slide()
	#var collision = move_and_collide(velocity * delta)
	#if collision:
		#velocity = velocity.bounce(collision.get_normal())
		#rotation = velocity.angle()


func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta


func handle_jump():
	var jump = "jump" + controller_id
	if is_on_floor() and Input.is_action_just_pressed(jump):
		velocity.y = jump_velocity
	elif Input.is_action_just_released("jump" + controller_id) and velocity.y < jump_velocity / 2:
		velocity.y = jump_velocity / 2

func handle_shoot():
	var up = "up" + controller_id
	var down = "down" + controller_id
	if Input.is_action_just_pressed("shoot" + controller_id):
		var b = Bullet.instantiate()
		get_tree().root.add_child(b)
		if facing_left and not Input.is_action_pressed(up) and not Input.is_action_pressed(down):
			muzzle.position = Vector2(-16, -8)
			b.set_speed(Vector2(-1, 0))
		elif not facing_left and not Input.is_action_pressed(up) and not Input.is_action_pressed(down):
			muzzle.position = Vector2(16, -8)
			b.set_speed(Vector2(1, 0))
		if Input.is_action_pressed(up):
			muzzle.position = Vector2(0, -24)
			b.set_speed(Vector2(0, -1))
		elif Input.is_action_pressed(down):
			muzzle.position = Vector2(0, 16)
			b.set_speed(Vector2(0, 1))
		if aim_input.x != 0 or aim_input.y != 0:
			b.set_speed(aim_input)
		b.transform = $Muzzle.global_transform

func apply_friction(input_axis, delta):
	if input_axis == 0:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

func apply_accel(input_axis, delta):
	if input_axis:
		velocity.x = move_toward(velocity.x, SPEED * input_axis, ACCEL * delta)

func update_animation(input_axis):
	animated_sprite_2d.flip_h = facing_left
	animated_sprite_2d.flip_v = gravity < 0
	if input_axis != 0:
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
	
	if not is_on_floor():
		animated_sprite_2d.play("jump")

#HEALTH BAR
@onready var healthbar = $HealthBar

func _ready():
	if self == null:
		return
	healthbar.init_health(health)

func update_health(h):
	health = h
	healthbar._set_health(health)
	if health <= 0:
		queue_free()
		$/root/Level_1/MultiTargetCamera2D.remove_target(self)
