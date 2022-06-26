extends Area2D


var velocity = Vector2();
var speed = 400;
onready var sprite = get_node("sprite")
# var b = "text"
var death = false
var init = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if not death:
		if init:
			sprite.play('instance')
		else:
			sprite.play('idle')
	else:
		sprite.play("death")
		
	translate(velocity)


func _on_sprite_animation_finished():
	if sprite.animation == "death":
		queue_free()
	elif sprite.animation == "instance":
		init = false


func _on_demon_bullet_body_entered(body):
	death = true
