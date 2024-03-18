extends CanvasLayer
@onready var combined = $combined
@onready var player_1 = $"../../Player1"
@onready var player_2 = $"../../Player2"
@onready var multi_target_camera_2d = $".."
@onready var health_bar_1 = $HealthBar1
@onready var health_bar_2 = $HealthBar2
@onready var shield_bar_1 = $ShieldBar1
@onready var shield_bar_2 = $ShieldBar2

#func _ready():
	#health_bar_1.init_health(player_1.health)
	#health_bar_2.init_health(player_2.health)
	#shield_bar_1.init_health(player_1.shield)
	#shield_bar_2.init_health(player_2.shield)
	
func _process(_delta):
	combined.text = str(player_1.num_lives) + ":" + str(player_2.num_lives)
	#health_bar_1._set_health(player_1.health)
	#health_bar_2._set_health(player_2.health)
	#shield_bar_1._set_health(player_1.shield)
	#shield_bar_2._set_health(player_2.shield)
	
	



	  
