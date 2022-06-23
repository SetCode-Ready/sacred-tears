extends Node2D


onready var tween = get_node("tween")
onready var text = get_node("text")
export(String, MULTILINE) var texto_popup

func _ready():
	text.text = texto_popup

func open_popup():
	$animation.play("open")


func close_popup():
	$animation.play_backwards("open")
	
	
func _on_opening_area_body_entered(body):
	if body.name.to_upper() == "PLAYER":
		open_popup()


func _on_opening_area_body_exited(body):
	if body.name.to_upper() == "PLAYER":
		close_popup()
