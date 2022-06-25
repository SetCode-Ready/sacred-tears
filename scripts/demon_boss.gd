extends KinematicBody2D

onready var sprite = $AnimatedSprite
onready var player_detection_zone = $PlayerDetectionZone

const GRAVITY = 2000

const MAX_SPEED = 1

var motion = Vector2.ZERO

var direction = 1

var is_attacking = false

var can_chase_player = false

var is_player_on_area_detector = true

var boss_status_bar = null


func _physics_process(delta):
	move()
	

func move():
	if not is_attacking:
		sprite.play("Walk")
		
	seek_player()
	
	if (can_chase_player):
		var player = player_detection_zone.player
		if player != null:
			boss_status_bar = player.get_node("PlayerHUD").get_node("BossHealthBar")
			boss_status_bar.visible = true
			direction = 1 if (player.global_position - global_position).normalized().x > 0 else -1
			motion.y += GRAVITY
			motion.x += MAX_SPEED * direction
	else:
		motion.y += GRAVITY
		motion.x += MAX_SPEED * direction
	
	
	detect_turn_around(motion.x)
	
	motion = move_and_slide(motion)
	


func seek_player():
	if player_detection_zone.can_see_player():
		can_chase_player = true


func detect_turn_around(x_axis):
	if (x_axis < 0):
		scale.x = scale.y * 1
	else:
		scale.x = scale.y * -1


func _on_PlayerDetector_body_entered(body):
	boss_status_bar.value -= 10
	sprite.play("Attack")
	is_attacking = true


func _on_PlayerDetector_body_exited(body):
	is_player_on_area_detector = false


func _on_AnimatedSprite_animation_finished():
	if sprite.animation == "Attack" and not is_player_on_area_detector:
		is_attacking = false
