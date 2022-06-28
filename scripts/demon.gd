extends KinematicBody2D

export var life = 75
export var damage = 10

onready var player_detection_zone = $PlayerDetectionZone
onready var status_bar = $EnemyStatusBar

const MAX_SPEED = 352
const ACCELERETION = 352

var motion = Vector2.ZERO

var can_chase_player = false

var is_attacking = false

var is_player_on_area_detector = false

var is_moving_left = false

var is_dead = false

var player = null

var is_player_on_attack_area = false


func _ready():
	status_bar.value = life


func _process(delta):
	status_bar.value = life
	
	if life <= 0:
		is_dead = true
		death()
	
	if is_attacking or is_dead:
		return
	
	move(delta)
	


func move(delta):
	if not is_attacking:
		$Sprite.play("Idle")
	
	seek_player()
		
	if (can_chase_player):
		player = player_detection_zone.player
		if player != null:
			var direction = (player.global_position - global_position).normalized()
			motion = motion.move_toward(direction * MAX_SPEED, ACCELERETION * delta)
			detect_turn_around(motion.x)
			
			
	motion = move_and_slide(motion)
		

func death():
	$Sprite.play("Death")


func seek_player():
	if player_detection_zone.can_see_player():
		can_chase_player = true


func detect_turn_around(x_axis):
	if (x_axis > 0):
		is_moving_left = false
		scale.x = scale.y * 1
		status_bar.fill_mode = 0
	else:
		is_moving_left = true
		scale.x = scale.y * -1
		status_bar.fill_mode = 1


func _on_PlayerDetector_body_entered(body):
	$Sprite.play("Attack")	
	is_attacking = true
	is_player_on_area_detector = true


func _on_AttackDetector_body_entered(body):
	player = body
	is_player_on_attack_area = true


func _on_Sprite_animation_finished():
	if $Sprite.animation == "Attack" and is_player_on_attack_area:
		
		player.life -= damage
	elif $Sprite.animation == "Attack" and not is_player_on_area_detector:
		is_attacking = false
	
	if $Sprite.animation == "Death":
		queue_free()


func _on_PlayerDetector_body_exited(body):
	is_player_on_area_detector = false


func _on_HitArea_area_entered(area):
	if area.name == "Bullet":
		if not area.is_normal:
			get_node("damage_sound").play()
			life -= area.sacred_water_damage



func _on_AttackDetector_body_exited(body):
	player = null
	is_player_on_attack_area = false


func take_sword_damage(sword_damage):
	get_node("damage_sound").play()
	life -= sword_damage
