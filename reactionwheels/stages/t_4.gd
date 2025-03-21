extends Node2D

signal success
signal restart

func _on_button_pressed() -> void:
	pass
	#restart.emit

func _on_spacecraft_turn_ended() -> void:
	if len($Spacecraft/Output.contents) >= 4:
		success.emit()
