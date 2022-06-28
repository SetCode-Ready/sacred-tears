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
	OS.shell_open('https://clembod.itch.io/warrior-free-animation-set')


func _on_parallax_pressed():
	OS.shell_open('https://brullov.itch.io/oak-woods')


func _on_villagers_pressed():
	OS.shell_open('https://free-game-assets.itch.io/villagers-sprite-sheets-free-pixel-art-pack')


func _on_decoracao_pressed():
	OS.shell_open('https://cainos.itch.io/pixel-art-platformer-village-props')


func _on_demonio_pressed():
	get_tree().change_scene("https://toymaster.itch.io/monsters-pack")


func _on_demonio_boss_pressed():
	get_tree().change_scene("https://chierit.itch.io/boss-demon-slime")


func _on_animation_animation_finished(anim_name):
	get_tree().change_scene("res://scenes/interface/menu.tscn")


func _on_menu_pressed():
	OS.shell_open("https://www.youtube.com/watch?v=PwQr_YKgPh4&ab_channel=JulianLehmann%26Asuryan")


func _on_creditos_pressed():
	OS.shell_open("https://www.youtube.com/watch?v=bgq1jWu0REM&ab_channel=JulianLehmann%26Asuryan")


func _on_fase_inicial_pressed():
	OS.shell_open("https://www.youtube.com/watch?v=U6ugBjgTjes&ab_channel=DerekFiechter%27sMusic")


func _on_fase_boss_pressed():
	OS.shell_open("https://www.youtube.com/watch?v=Lbcvu5LF_aw&ab_channel=JacobLizotte")
