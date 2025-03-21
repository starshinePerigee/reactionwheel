extends Control

signal complete


func _on_spacecraft_turn_ended() -> void:
	if len($Spacecraft/S3Buffer.contents) >= 6:
		complete.emit()
