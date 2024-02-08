extends Area2D


# Called when the node enters the scene tree for the first time.
#func _ready():
	##if body entered the 2d Area
	#pass

func _on_body_entered(body):
	if body.is_in_group('players'):
		body.queue_free()
		$/root/Level_1/MultiTargetCamera2D.remove_target(body)
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

