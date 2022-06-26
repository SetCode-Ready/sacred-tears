extends KinematicBody2D


onready var sprite = get_node("sprite")
onready var cooldown = get_node("cooldown_attack")
onready var player_detection_zone = get_node("PlayerDetectionZone")

const bulletPath = preload("res://scenes/demon_bullet.tscn")

const GRAVITY = 2000

const MAX_SPEED = 1

var motion = Vector2.ZERO

var direction = 1

var is_attacking = false

var can_chase_player = false

var in_cooldown = false

var delta_var = 0

func _physics_process(delta):
	delta_var = delta
	move()
	

func move():
	if not is_attacking:
		sprite.play("run")
		
	seek_player()
	
	if (can_chase_player):
		var player = player_detection_zone.player
		if player != null:
			direction = 1 if (player.global_position - global_position).normalized().x > 0 else -1
			motion.y += GRAVITY
			motion.x += MAX_SPEED * direction
	else:
		motion.y += GRAVITY
		motion.x += MAX_SPEED * direction
	
	detect_turn_around(motion.x)
	
	motion = move_and_slide(motion)
	

func seek_player():
	if player_detection_zone.can_see_player() and not in_cooldown:
		is_attacking = true
		sprite.play('attack')
	elif not is_attacking:
		can_chase_player = true


func detect_turn_around(x_axis):
	if (x_axis > 0):
		scale.x = scale.y * 1
	else:
		scale.x = scale.y * -1

func instance_bullet(delta):
		var bullet = bulletPath.instance()
		get_parent().add_child(bullet)

		
		bullet.position = $castPosition.global_position
		bullet.speed += (MAX_SPEED)
		
		if motion.x > 0:
			bullet.rotation_degrees = 0
			bullet.velocity.x = direction*bullet.speed * delta
		else:
			bullet.rotation_degrees = 180
			bullet.velocity.x = direction*bullet.speed * delta


func _on_sprite_animation_finished():
	if sprite.animation == "attack":
		is_attacking = false
		instance_bullet(delta_var)
		in_cooldown = true
		cooldown.start()

func _on_cooldown_attack_timeout():
	in_cooldown = false
