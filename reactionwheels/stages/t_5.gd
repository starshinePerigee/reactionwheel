extends Node2D

signal success

func _on_button_pressed() -> void:
	pass
	#get_tree().reload_current_scene()


func _on_spacecraft_turn_ended() -> void:
	if len($Spacecraft/Buffer3) >= 3:
		success.emit()
