extends Control

func _ready():
	for child in get_children():
		child.visible = false
	$bg.visible = true
	$s1.visible = true
	$Label2.visible = true
	#$Button.visible=true

func _on_s_1_button_pressed() -> void:
	$s1.visible = false
	$s2.visible = true

func _on_s_2_action_fired() -> void:
	$s2.visible = false
	$s3.visible = true

func _on_s_3_complete() -> void:
	$s3.visible = false
	$T4.visible = true

func _on_t_4_success() -> void:
	$T4.visible = false
	$T5.visible = true

func _on_t_5_success() -> void:
	get_tree().change_scene_to_file("res://stages/level_10.tscn")
