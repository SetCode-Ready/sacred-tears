extends KinematicBody2D

export var life = 200
export var max_life = 200
export var boss_name = ""
export var damage = 20

onready var sprite = $AnimatedSprite
onready var player_detection_zone = $PlayerDetectionZone

const GRAVITY = 2000

const MAX_SPEED = 100
const ACCELERATION = 150

var motion = Vector2.ZERO

var direction = 1

var is_attacking = false

var can_chase_player = false

var is_player_on_area_detector = true

var is_dead = false

var player = null

var is_player_on_attack_area = false

var boss_status_bar = null
var boss_health_bar = null

var can_hit = true

var take_hit = false

func _process(delta):
	if boss_health_bar != null:
		boss_health_bar.value = life
		
	if life <= 0:
		is_dead = true
		death()
		
	if is_attacking:
		if $AnimatedSprite.frame == 10 and can_hit:
			get_node("attack_sound").play()
			can_hit = false
			hit_player()
		
	if is_attacking or is_dead:
		return
		
		
	if is_attacking and take_hit:
		is_attacking = false
		sprite.play("TakeHit")
	elif take_hit:
		sprite.play("TakeHit")
		
	move(delta)
	

func move(delta):
	if not is_attacking and not take_hit:
		sprite.play("Walk")
		
		
	seek_player()
	
	if (can_chase_player):
		player = player_detection_zone.player
		if player != null:
			get_boss_status_bar(player)
			direction = 1 if (player.global_position - global_position).normalized().x > 0 else -1
			motion.y += GRAVITY
			motion.x += ACCELERATION * direction
			motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
	else:
		motion.y += GRAVITY
		motion.x += MAX_SPEED * direction
	
	
	detect_turn_around(motion.x)
	
	motion = move_and_slide(motion)
	

func get_boss_status_bar(player):
	boss_status_bar = player.get_node("PlayerHUD").get_node("BossStatusBar")
	boss_health_bar = boss_status_bar.get_node("BossHealthBar")
	boss_health_bar.max_value = max_life
	boss_status_bar.visible = true
	boss_status_bar.get_node("BossName").text = boss_name


func seek_player():
	if player_detection_zone.can_see_player():
		can_chase_player = true


func detect_turn_around(x_axis):
	if (x_axis < 0):
		scale.x = scale.y * 1
	else:
		scale.x = scale.y * -1


func death():
	$idle_sound.play()
	sprite.play("Death")


func _on_PlayerDetector_body_entered(body):
	sprite.play("Attack")
	is_attacking = true
	is_player_on_area_detector = true
	


func _on_PlayerDetector_body_exited(body):
	is_player_on_area_detector = false


func _on_AnimatedSprite_animation_finished():
	if sprite.animation == "Attack" and not is_player_on_area_detector:
		can_hit = true
		is_attacking = false
	elif sprite.animation == "Attack":
		can_hit = true
		
	if sprite.animation == "TakeHit":
		take_hit = false
		
	if sprite.animation == "Death":
		boss_status_bar.visible = false
		queue_free()


func hit_player():
	if is_player_on_attack_area:
		player.life -= damage


func _on_HitArea_area_entered(area):
	if area.name == "Bullet":
		$damage_sound.play()
		if not area.is_normal:
			take_hit = true
			life -= area.sacred_water_damage


func _on_AttackDetector_body_entered(body):
	player = body
	is_player_on_attack_area = true


func _on_AttackDetector_body_exited(body):
	player = null
	is_player_on_attack_area = false


func take_sword_damage(sword_damage):
	$damage_sound.play()
	life -= sword_damage
