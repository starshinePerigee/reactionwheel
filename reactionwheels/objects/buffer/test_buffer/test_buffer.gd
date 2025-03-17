extends Node2D

func _on_line_edit_text_submitted(new_text: String) -> void:
	$Buffer.content_size = int(new_text)
