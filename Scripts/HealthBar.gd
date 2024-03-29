extends ProgressBar

@onready var timer =  $Timer
@onready var dmgbar = $Dmgbar

var health = 0 : set = _set_health

func _set_health(new_health):
	var prev_health = health
	health = min(max_value, new_health)
	value = health
	
	if health <= 0:
		return
		
	if health < prev_health:
		timer.start()
	else:
		#dmgbar.value = health
		pass
		

func init_health(_health):
	health = _health
	max_value = health
	value = health
	#dmgbar.value = health
	#dmgbar.max_value = health

func _on_timer_timeout():
	dmgbar.value = health
