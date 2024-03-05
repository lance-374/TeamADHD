extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var chase = false
var SPEED = 50
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.y += gravity * delta #gravity for enemy:frog
	if chase == true:
		player = get_node("../../Player/Player")
		var direction = (player.position - self.position)
		if direction.x > 0:
			print("R")
			get_node("AnimatedSprite2D").flip_h = true
			
		else:
			print("L")
			get_node("AnimatedSprite2D").flip_h = false
		velocity.x = direction.x * SPEED
	else:
		velocity.x = 0
	move_and_slide()

func _on_player_detection_body_entered(body):
	if body.name == "Player":
		chase = true
		
		


func _on_player_detection_body_exited(body):
	chase = false
