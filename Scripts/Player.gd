extends CharacterBody2D

const SPEED = 200
const FRICTION = 2000
const ACCEL = 1200

var aim_input = Vector2.ZERO
var gravity_flipped = false
var dead = false
@export var controller_id = "0"
var jump_velocity = -600.0
var gravity = 1960
@export var starting_health = 100
@export var starting_shield = 50
@export var starting_facing_left = false
@export var starting_recharge = 1
@export var num_lives = 3

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var muzzle = $Muzzle
@onready var Bullet = preload("res://Objects/bullet.tscn")
@onready var collision_shape_2d = $CollisionShape2D
@onready var shield_cooldown = $ShieldCooldown
@onready var auto_fire_timer = $AutoFireTimer

@onready var health_bar_1 = $"../MultiTargetCamera2D/HUD/HealthBar2"
@onready var health_bar_2 = $"../MultiTargetCamera2D/HUD/HealthBar1"
@onready var shield_bar_1 = $"../MultiTargetCamera2D/HUD/ShieldBar2"
@onready var shield_bar_2 = $"../MultiTargetCamera2D/HUD/ShieldBar1"



var facing_left
var blocking = false
var moonwalk = false
var starting_position
var health: int
var shield: int
var recharge
var vampirism = false
var machine_gun = false

func _ready():
	if self == null:
		return
	health = starting_health
	shield = starting_shield
	facing_left = starting_facing_left
	recharge = starting_recharge
	starting_position = position
	if controller_id == "1":
		print("init_health player 1")
		health_bar_1.init_health(starting_health)
		shield_bar_1.init_health(starting_shield)
	else:
		health_bar_2.init_health(starting_health)
		shield_bar_2.init_health(starting_shield)
	shield_cooldown.start()

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
		if not machine_gun:
			muzzle.position = Vector2(-20, -12)
		else:
			muzzle.position = Vector2(-20, -42)
	elif not facing_left and gravity_flipped:
		collision_shape_2d.position = Vector2(0,-40)
		if not machine_gun:
			muzzle.position = Vector2(26, -12)
		else:
			muzzle.position = Vector2(26, -42)
	elif facing_left and not gravity_flipped:
		collision_shape_2d.position = Vector2(14,2)
		if not machine_gun:
			muzzle.position = Vector2(-20, -24)
		else:
			muzzle.position = Vector2(-20, 4)
	elif not facing_left and not gravity_flipped:
		collision_shape_2d.position = Vector2(0,2)
		if not machine_gun:
			muzzle.position = Vector2(26, -24)
		else:
			muzzle.position = Vector2(26, 4)

func apply_gravity(delta):
	if not is_on_floor_or_ceiling():
		velocity.y += gravity * delta

func handle_block():
	if Input.is_action_pressed("block" + controller_id) and not dead:
		blocking = true
	else:
		blocking = false

func reverse_gravity():
	gravity *= -1
	jump_velocity *= -1
	gravity_flipped = gravity < 0

func handle_jump():
	var jump = "jump" + controller_id
	if not dead and not blocking:
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

func handle_shoot(autofire=false):
	var up = "up" + controller_id
	var down = "down" + controller_id
	if (Input.is_action_just_pressed("shoot" + controller_id) or autofire) and not dead:
		var b = Bullet.instantiate()
		b.set_player(controller_id, self, vampirism)
		get_tree().root.add_child(b)
		if facing_left and not Input.is_action_pressed(up) and not Input.is_action_pressed(down) and not machine_gun:
			b.set_speed(Vector2(-1, 0))
		elif not facing_left and not Input.is_action_pressed(up) and not Input.is_action_pressed(down) and not machine_gun:
			b.set_speed(Vector2(1, 0))
		if Input.is_action_pressed(up) and not machine_gun:
			b.set_speed(Vector2(0, -1))
		elif Input.is_action_pressed(down) and not machine_gun:
			b.set_speed(Vector2(0, 1))
		if (aim_input.x != 0 or aim_input.y != 0) and not moonwalk and not machine_gun:
			b.set_speed(aim_input)
		if machine_gun:
			if facing_left:
				b.set_speed(Vector2(-1, 0))
			else:
				b.set_speed(Vector2(1, 0))
		b.transform = muzzle.global_transform

func apply_friction(input_axis, delta):
	if input_axis == 0:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

func toggle_machine_gun():
	if machine_gun:
		machine_gun = false
		auto_fire_timer.stop()
	else:
		machine_gun = true
		auto_fire_timer.start()

func _on_auto_fire_timer_timeout():
	if machine_gun:
		auto_fire_timer.start()
	handle_shoot(true)

func apply_acceleration(input_axis, delta):
	if input_axis and not dead:
		velocity.x = move_toward(velocity.x, SPEED * input_axis, ACCEL * delta)

func update_animation(input_axis):
	animated_sprite_2d.flip_h = facing_left
	animated_sprite_2d.flip_v = gravity_flipped
	if not dead:
		if input_axis != 0 and not machine_gun:
			animated_sprite_2d.play("run")
		elif not is_on_floor_or_ceiling() and not machine_gun:
			animated_sprite_2d.play("jump")
		elif not machine_gun:
			animated_sprite_2d.play("idle")
		if blocking and not machine_gun:
			animated_sprite_2d.play("block")
		if machine_gun:
			animated_sprite_2d.play("machine_gun")

func update_health(h):
	health = h
	if health > 100:
		health = 100
	if controller_id == "1":
		health_bar_1._set_health(health)
	else:
		health_bar_2._set_health(health)
	if health <= 0:
		death()

func subtract_health(h):
	if not blocking or shield <= 0:
		health -= h
		if controller_id == "1":
			health_bar_1._set_health(health)
		else:
			health_bar_2._set_health(health)
	else:
		shield -= h
		if shield < 0:
			shield = 0
		if controller_id == "1":
			shield_bar_1._set_health(shield)
		else:
			shield_bar_2._set_health(shield)
	if health <= 0:
		death()

func add_shield(s):
	if shield < 50:
		shield += s
		if shield > 50:
			shield = 50
	if controller_id == "1":
		shield_bar_1._set_health(shield)
	else:
		shield_bar_2._set_health(shield)

func _on_timer_timeout():
	if shield < 50 and not blocking:
		add_shield(recharge)
	shield_cooldown.start()

func death():
	dead = true
	animated_sprite_2d.play("death")

func _on_animated_sprite_2d_animation_finished():
	if dead:
		num_lives -= 1
		if num_lives == 0:
			if controller_id == "1":
				get_tree().change_scene_to_file("res://Levels/blaze_wins_screen.tscn")
			else:
				get_tree().change_scene_to_file("res://Levels/echo_wins_screen.tscn")
		else:
			dead = false
			facing_left = starting_facing_left
			position = starting_position
			shield = starting_shield
			health = starting_health
			if controller_id == "1":
				shield_bar_1._set_health(shield)
				health_bar_1._set_health(health)
			else:
				shield_bar_2._set_health(shield)
				health_bar_2._set_health(health)
				
