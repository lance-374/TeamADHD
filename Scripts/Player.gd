extends CharacterBody2D

const SPEED = 200
const FRICTION = 2000
const ACCEL = 1200

var aim_input = Vector2.ZERO
var gravity_flipped = false
@export var controller_id = "0"
@export var jump_velocity = -600.0
@export var gravity = 1960
@export var health = 100

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var muzzle = $Muzzle
@onready var Bullet = preload("res://Objects/bullet.tscn") # Will load when parsing the script
@onready var healthbar = $HealthBar
@onready var collision_shape_2d = $CollisionShape2D
var facing_left = false
var blocking = false
var moonwalk = false

func _ready():
	if self == null:
		return
	healthbar.init_health(health)

func _physics_process(delta):
	if self == null:
		return
	apply_gravity(delta)
	handle_jump()
	var input_axis = 0
	if not moonwalk:
		input_axis = Input.get_axis("left" + controller_id, "right" + controller_id)
	else:
		input_axis = Input.get_axis("right" + controller_id, "left" + controller_id)
	if input_axis < 0 and not moonwalk:
		facing_left = true
	if input_axis > 0 and not moonwalk:
		facing_left = false
	if input_axis < 0 and moonwalk:
		facing_left = false
	if input_axis > 0 and moonwalk:
		facing_left = true
	if blocking:
		input_axis = 0
	aim_input.x = Input.get_action_strength("rs_right" + controller_id) - Input.get_action_strength("rs_left" + controller_id)
	aim_input.y = Input.get_action_strength("rs_down" + controller_id) - Input.get_action_strength("rs_up" + controller_id)
	if aim_input.x < 0:
		facing_left = true
	if aim_input.x > 0:
		facing_left = false
	handle_shoot()
	apply_acceleration(input_axis, delta)
	apply_friction(input_axis, delta)
	update_animation(input_axis)
	handle_block()
	move_and_slide()
	
#	update positions of everything, TODO improve this using PositionNode2D
	if facing_left and gravity_flipped:
		collision_shape_2d.position = Vector2(14,-40)
		healthbar.position = Vector2(-20, 12)
		muzzle.position = Vector2(-20, -12)
	elif not facing_left and gravity_flipped:
		collision_shape_2d.position = Vector2(0,-40)
		healthbar.position = Vector2(-32, 12)
		muzzle.position = Vector2(26, -12)
	elif facing_left and not gravity_flipped:
		collision_shape_2d.position = Vector2(14,2)
		healthbar.position = Vector2(-20, -52)
		muzzle.position = Vector2(-20, -24)
	elif not facing_left and not gravity_flipped:
		collision_shape_2d.position = Vector2(0,2)
		healthbar.position = Vector2(-32, -52)
		muzzle.position = Vector2(26, -24)

func apply_gravity(delta):
	if not is_on_floor_or_ceiling():
		velocity.y += gravity * delta

func handle_block():
	if Input.is_action_pressed("block" + controller_id):
		animated_sprite_2d.play("block")
		blocking = true
	else:
		blocking = false

func reverse_gravity():
	gravity *= -1
	jump_velocity *= -1
	gravity_flipped = gravity < 0

func handle_jump():
	var jump = "jump" + controller_id
	if is_on_floor_or_ceiling() and Input.is_action_just_pressed(jump):
		velocity.y = jump_velocity 
	elif Input.is_action_just_released("jump" + controller_id) and jump_velocity_compare():
		velocity.y = jump_velocity / 2

func jump_velocity_compare():
	if gravity > 0:
		return velocity.y < jump_velocity / 2
	else:
		return velocity.y > jump_velocity / 2
		
func is_on_floor_or_ceiling():
	if gravity > 0:
		return is_on_floor()
	else:
		return is_on_ceiling()


func handle_shoot():
	var up = "up" + controller_id
	var down = "down" + controller_id
	if Input.is_action_just_pressed("shoot" + controller_id):
		var b = Bullet.instantiate()
		get_tree().root.add_child(b)
		if facing_left and not Input.is_action_pressed(up) and not Input.is_action_pressed(down):
			b.set_speed(Vector2(-1, 0))
		elif not facing_left and not Input.is_action_pressed(up) and not Input.is_action_pressed(down):
			b.set_speed(Vector2(1, 0))
		if Input.is_action_pressed(up):
			b.set_speed(Vector2(0, -1))
		elif Input.is_action_pressed(down):
			b.set_speed(Vector2(0, 1))
		if aim_input.x != 0 or aim_input.y != 0:
			b.set_speed(aim_input)
		b.transform = muzzle.global_transform

func apply_friction(input_axis, delta):
	if input_axis == 0:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

func apply_acceleration(input_axis, delta):
	if input_axis:
		velocity.x = move_toward(velocity.x, SPEED * input_axis, ACCEL * delta)

func update_animation(input_axis):
	animated_sprite_2d.flip_h = facing_left
	animated_sprite_2d.flip_v = gravity_flipped
	if input_axis != 0:
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
	if not is_on_floor() and gravity > 0:
		animated_sprite_2d.play("jump")
	elif not is_on_ceiling and gravity < 0:
		animated_sprite_2d.play("jump")

func update_health(h):
	health = h
	healthbar._set_health(health)
	if health <= 0:
		death()

func subtract_health(h):
	if not blocking:
		health -= h
	else:
		health -= h/2
	healthbar._set_health(health)
	if health <= 0:
		death()

func death():
	queue_free()
	if controller_id == "1":
		get_tree().change_scene_to_file("res://Levels/blaze_wins_screen.tscn")
	else:
		get_tree().change_scene_to_file("res://Levels/echo_wins_screen.tscn")
	#TODO add death animation here
