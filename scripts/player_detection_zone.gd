extends Area2D

var player = null
export var tamanho_x = 1.5
export var tamanho_y = 1.0


func _process(delta):
	scale.x = tamanho_x
	scale.y = tamanho_y

func can_see_player():
	return player != null


func _on_PlayerDetectionZone_body_entered(body):
	if (body.name == "Player"):
		player = body
	
	
func _on_PlayerDetectionZone_body_exited(body):
	player = null
	
