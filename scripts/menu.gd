extends Node2D

onready var fade = get_node("fade")
var press_type = 'none'

func _on_Start_pressed():
	$animation.play("fade")
	press_type = 'start'


func _on_Creditos_pressed():
	$animation.play("fade")
	press_type = 'creditos'


func _on_animation_animation_finished(anim_name):
	if press_type == 'creditos':
		get_tree().change_scene("res://scenes/interface/creditos.tscn")
	elif press_type == 'start':
		get_tree().change_scene("res://scenes/levels/fase_01.tscn")
