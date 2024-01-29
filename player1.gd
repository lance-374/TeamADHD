extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -300.0
const FRICTION = 1000
const ACCEL = 600

#var controller_index = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite_2d = $AnimatedSprite2D
#@onready var Bullet = $Bullet
var Bullet = preload("res://world.tscn") # Will load when parsing the script.
#@export var Bullet : PackedScene
#var Bullet = preload("res://bullet.tscn") # Will load when parsing the script.


func _physics_process(delta):
	apply_gravity(delta)
	handle_jump()
	var input_axis = Input.get_axis("left2", "right2")
	handle_shoot()
	apply_accel(input_axis, delta)
	apply_friction(input_axis, delta)
	update_animation(input_axis)
	move_and_slide()
	
func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

var jump = 'jump2'
func handle_jump():
	if is_on_floor() and Input.is_action_just_pressed(jump):
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_released(jump) and velocity.y < JUMP_VELOCITY / 2:
		velocity.y = JUMP_VELOCITY / 2

func handle_shoot():
	if Input.is_action_just_pressed("shoot2"):
		var b = Bullet.instantiate()
		get_tree().root.add_child(b)
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

