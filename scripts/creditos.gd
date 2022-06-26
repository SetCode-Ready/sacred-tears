extends Node2D

func _on_button_back_pressed():
	$animation.play("fade")


func _on_Emanuel_pressed():
	OS.shell_open('https://github.com/Emanuelvss13')


func _on_Filipe_pressed():
	OS.shell_open('https://github.com/Filipecard')


func _on_Kaue_pressed():
	OS.shell_open('https://github.com/kauecdev')


func _on_Cicero_pressed():
	OS.shell_open('https://github.com/cicerohss')


func _on_link_labiras_pressed():
	OS.shell_open('https://www.linkedin.com/company/labiras/')


func _on_personagem_pressed():
	OS.shell_open('')


func _on_parallax_pressed():
	OS.shell_open('')


func _on_villagers_pressed():
	OS.shell_open('')


func _on_decoracao_pressed():
	OS.shell_open('')
	pass # Replace with function body.


func _on_demonio_menor_pressed():
	OS.shell_open('')
	pass # Replace with function body.


func _on_demonio_aracne_pressed():
	OS.shell_open('')
	pass # Replace with function body.


func _on_demonio_voador_pressed():
	OS.shell_open('')
	pass # Replace with function body.


func _on_demonio_boss_pressed():
	OS.shell_open('')
	pass # Replace with function body.


func _on_animation_animation_finished(anim_name):
	get_tree().change_scene("res://scenes/interface/menu.tscn")
