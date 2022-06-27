extends Area2D

var player
var in_saint = false


func _on_saint_body_entered(body):
	if body.name.to_upper() == 'PLAYER':
		player = body
		in_saint = true
		$timer.start()


func _on_saint_body_exited(body):
	in_saint = false


func _on_timer_timeout():
	if player.normal_water > 0 and player.sacred_water < 100 and in_saint:
		player.sacred_water += 1 
		player.normal_water -= 1
