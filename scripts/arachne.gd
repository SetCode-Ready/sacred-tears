extends KinematicBody2D

export var life = 60
export var damage = 5

onready var status_bar = $EnemyStatusBar

const GRAVITY = 2000
const ACCELERETION = 140

var motion = Vector2.ZERO

var is_moving_left = false

var is_attacking = false

var is_player_on_attack_area = false

var player = null

var is_dead = false

func _ready():
	status_bar.value = life
	start_walk()
	

func _process(delta):
	status_bar.value = life
	
	if life <= 0:
		is_dead = true
		death()
	
	if is_attacking or is_dead:
		return
	else:
		start_walk()
	
	move()
	
	detect_turn_around()
	

func move():
	motion.x = -ACCELERETION if is_moving_left else ACCELERETION
	
	motion.y += GRAVITY
	
	motion = move_and_slide(motion, Vector2.UP)


func detect_turn_around():
	if not $RayCast2D.is_colliding() and is_on_floor():
		is_moving_left = !is_moving_left
		scale.x = -scale.x
		status_bar.fill_mode = 0
	elif is_on_wall():
		is_moving_left = !is_moving_left
		scale.x = -scale.x
		status_bar.fill_mode = 1


func start_walk():
	$Sprite.play("Walk")
	
	
func death():
	$Sprite.play("Death")


func _on_PlayerDetector_body_entered(body):
	$Sprite.play("Attack")
	is_attacking = true


func _on_AttackDetector_body_entered(body):
	player = body
	is_player_on_attack_area = true


func _on_Sprite_animation_finished():
	if $Sprite.animation == "Attack" and is_player_on_attack_area:
		player.life -= damage
	elif $Sprite.animation == "Attack":
		is_attacking = false
	
	if $Sprite.animation == "Death":
		queue_free()

func _on_AttackDetector_body_exited(body):
	player = null
	is_player_on_attack_area = false


func _on_HitArea_area_entered(area):
	if area.name == "Bullet":
		if not area.is_normal:
			life -= area.sacred_water_damage


func take_sword_damage(sword_damage):
	life -= sword_damage
