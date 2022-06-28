extends Area2D

export var damage = 15

onready var sprite = get_node("sprite")

var velocity = Vector2();
var speed = 400;
var death = false
var init = true


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
	if body.is_in_group("player"):
		var chosen = (randi() % $damage_player_sound.get_child_count()) + 1
		get_node("damage_player_sound/damage-" + str(chosen)).play()
		body.life -= damage
	death = true
