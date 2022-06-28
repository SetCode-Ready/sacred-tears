extends Area2D

var player
var in_saint = false
export var life_saint = 50
var regen_pressed = false
onready var status_bar = $life_progres_saint



func _process(delta):
	status_bar.value = life_saint
	
	if Input.is_action_pressed("ui_regen") and player.life < 100 and life_saint > 0 and in_saint:
		player.life += 0.125
		life_saint -= 0.125

func _on_saint_body_entered(body):
	if body.name.to_upper() == 'PLAYER':
		var chosen = (randi() % $healed_sound.get_child_count()) + 1
		get_node("healed_sound/healed-" + str(chosen)).play()
		player = body
		in_saint = true
		if life_saint > 0:
			$info_button.visible = true
			$life_button.visible = true
		$timer.start()


func _on_saint_body_exited(body):
	$info_button.visible = false
	$life_button.visible = false
	in_saint = false


func _on_timer_timeout():
	if player.normal_water > 0 and player.sacred_water < 100 and in_saint:
		player.sacred_water += 1 
		player.normal_water -= 1


