extends Area2D


# Called when the node enters the scene tree for the first time.
#func _ready():
	##if body entered the 2d Area
	#pass

func _on_body_entered(body):
	if body.is_in_group('players'):
		body.death()
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

