extends Node




func _on_button_pressed():
	get_tree().change_scene_to_file("res://lore_2.tscn")

func _process(_float):
	if Input.is_action_just_pressed("jump1"):
		get_tree().change_scene_to_file("res://lore_2.tscn")
