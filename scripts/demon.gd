extends KinematicBody2D

onready var player_detection_zone = $PlayerDetectionZone

const MAX_SPEED = 480
const ACCELERETION = 480

var motion = Vector2.ZERO

var can_chase_player = false

var is_attacking = false

var is_player_on_area_detector = false

var is_moving_left = false

func _process(delta):
	if is_attacking:
		return
	

func _physics_process(delta):
	move(delta)
	

func move(delta):
	if not is_attacking:
		$Sprite.play("Idle")
	
	seek_player()
		
	if (can_chase_player):
		var player = player_detection_zone.player
		if player != null:
			var direction = (player.global_position - global_position).normalized()
			motion = motion.move_toward(direction * MAX_SPEED, ACCELERETION * delta)
			detect_turn_around(motion.x)
			
			
	motion = move_and_slide(motion)
		

func seek_player():
	if player_detection_zone.can_see_player():
		can_chase_player = true

#
func detect_turn_around(x_axis):
	if (x_axis > 0):
		is_moving_left = false
		scale.x = scale.y * 1
	else:
		is_moving_left = true
		scale.x = scale.y * -1


func _on_PlayerDetector_body_entered(body):
	$Sprite.play("Attack")
	is_attacking = true
	is_player_on_area_detector = true


func _on_AttackDetector_body_entered(body):
	pass


func _on_Sprite_animation_finished():
	if $Sprite.animation == "Attack" and not is_player_on_area_detector:
		is_attacking = false



func _on_PlayerDetector_body_exited(body):
	is_player_on_area_detector = false
