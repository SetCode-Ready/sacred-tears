extends Area2D


onready var area_entred = get_node("PlayerDetectionZone")
onready var sprite = get_node("sprite")
onready var animation = get_node("animation")

export var teleport_to_fase = 'nome da fase'
# var a = 2
# var b = "text"
var opened = false

# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play("close")


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_animation_animation_finished(anim_name):
	if anim_name == 'open':
		animation.play('idle')


func _on_PlayerDetectionZone_body_entered(body):
	if body.name.to_upper() == "PLAYER":
		animation.play('open')


func _on_PlayerDetectionZone_body_exited(body):
	if body.name.to_upper() == "PLAYER":
		animation.play("close")
	


func _on_portal_body_entered(body):
	if body.name.to_upper() == "PLAYER":
		print("res://scenes/levels/%s.tscn" % teleport_to_fase)
		get_tree().change_scene("res://scenes/levels/%s.tscn" % teleport_to_fase)
