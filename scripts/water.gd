extends Area2D

var player
var in_watter = false
func _ready():
	pass # Replace with function body.


#func _process(delta):
#	pass


func _on_water_body_entered(body):
	print(body.name)
	if body.name.to_upper() == 'PLAYER':
		player = body
		in_watter = true
		$cooldown.start()


func _on_cooldown_timeout():
	if player.normal_water < 100 and in_watter:
		player.normal_water += 1


func _on_water_body_exited(body):
	in_watter = false
