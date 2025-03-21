extends Node2D


func _on_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_spacecraft_turn_ended() -> void:
	if $Spacecraft/BufferSignal.contents.count(SliceData.DOWNLINK) >= 6:
		$TextureRect3.visible = true
