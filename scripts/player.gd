extends KinematicBody2D

export var life = 100
export var normal_water = 100
export var sacred_water = 100
export var sword_damage = 10
export var normal_water_shot_cost = 10
export var sacred_water_shot_cost = 10
export var double_jump_cost = 10

onready var particles = get_node("JetpackParticles")
onready var timer_particle = get_node("timerParticle")
onready var bulletspawn = get_node("BulletSpawn")
onready var sacredEffect = get_node("SacredEffect")
onready var state_machine = $AnimationTree.get("parameters/playback")
onready var sword = $Sword

onready var player_health_bar = $PlayerHUD/ProgressBarContainer/HealthBar
onready var player_normal_water_bar = $PlayerHUD/ProgressBarContainer/NormalWaterBar
onready var player_sacred_water_bar = $PlayerHUD/ProgressBarContainer/SacredWaterBar

const bulletPath = preload("res://scenes/Bullet.tscn")

const ACCELERATION = 512
const MAX_SPEED = 320
const FRICTION = 1
const GRAVITY = 2000
const JUMP_FORCE = 700

var motion = Vector2.ZERO

var can_double_jump = false

var is_attacking = false

var is_moving_left = false

var is_shooting = false

var is_moving = false

var is_normal_bullet = true

var thorns = null
var cooldown_hit = false

func _ready():
	player_health_bar.value = life
	player_normal_water_bar.value = normal_water
	player_sacred_water_bar.value = sacred_water


func _physics_process(delta):

	
	player_health_bar.value = life
	player_normal_water_bar.value = normal_water
	player_sacred_water_bar.value = sacred_water
	
	if life <= 0:
		state_machine.travel("Death")
		return
	
	player_move(delta)
	
	detect_turn_around()
	
	play_jump_animation()
	
	player_attack()
	
	player_shoot(delta)
	
	change_type_bullet()

	thorns_damage_player()
	
	
func player_move(delta):
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") 
	
	if x_input != 0:
		is_moving = true
		if not is_attacking or not is_shooting:
			if not get_node("running_sound/running-1").is_playing() and not state_machine.travel("Jump"):
				get_node("running_sound/running-1").play()
			state_machine.travel("Run")
		motion.x += x_input * ACCELERATION
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		bulletspawn.position.y = -15
		if x_input > 0:	
			is_moving_left = false
			bulletspawn.position.x = 20
			particles.position.x = -10 
			particles.process_material.gravity.x = -40
			particles.process_material.tangential_accel = 100
		else:
			is_moving_left = true
			bulletspawn.position.x = -15
			particles.position.x = 14
			particles.process_material.gravity.x = 90
			particles.process_material.tangential_accel = -100
			
	else:
		get_node("running_sound/running-1").stop()
		is_moving = false
		bulletspawn.position.y = -20
		if not is_attacking or not is_shooting:
			state_machine.travel("Idle")

			
		motion.x = lerp(motion.x, 0, FRICTION)
		
	motion.y += GRAVITY * delta
	
	player_jump()
	
	motion = move_and_slide(motion, Vector2.UP)


func player_jump():
	if Input.is_action_just_pressed("ui_accept"):
		get_node("running_sound/running-1").stop()
		if is_on_floor():
			var chosen = (randi() % $jump_sound.get_child_count()) + 1
			get_node("jump_sound/jump-" + str(chosen)).play()
			can_double_jump = true
			motion.y = -JUMP_FORCE
			
		if not is_on_floor() and can_double_jump and normal_water >= double_jump_cost and Input.is_action_just_pressed("ui_accept"):
			get_node("double_jump").play()
			normal_water -= double_jump_cost
			particles.emitting = true
			timer_particle.start()
			motion.y = -JUMP_FORCE
			can_double_jump = false
		
		

func play_jump_animation():
	if not is_on_floor():
		if not is_attacking:
			state_machine.travel("Jump")
	else:
		particles.emitting = false


func detect_turn_around():
	$SpriteAnimation.flip_h = true if is_moving_left else false
	$SacredEffect.position.x = (8 if is_moving_left else 0)
	$PlayerCollisionShape.position.x = (8 if is_moving_left else 0)
	$HitArea/collision.position.x = (8 if is_moving_left else 0)
	sword.get_node("CollisionShape2D").position.x = (-10 if is_moving_left else 18)
	

func player_attack():
	if Input.is_action_just_pressed("left_click"):
		var chosen = (randi() % $attack_sound.get_child_count()) + 1
		get_node("attack_sound/attack-" + str(chosen)).play()
		state_machine.travel("Attack")
		

func player_shoot(delta):
	# tecla z atira
	if Input.is_action_just_pressed("shoot") and ((is_normal_bullet and normal_water >= normal_water_shot_cost) or (not is_normal_bullet and sacred_water >= sacred_water_shot_cost)):
		get_node("shoot_sound").play()
		is_shooting = true
		if not is_moving:
			state_machine.travel("IdleAttack")
		
		var bullet = bulletPath.instance()
		get_parent().add_child(bullet)
		
		if is_normal_bullet:
			normal_water -= normal_water_shot_cost
		else:
			sacred_water -= sacred_water_shot_cost
		
		bullet.is_normal = is_normal_bullet
		
		bullet.position = bulletspawn.global_position
		bullet.speed = MAX_SPEED + 100
		
		if is_moving_left:
			bullet.rotation_degrees = 0
			bullet.velocity.x = -bullet.speed * delta
		else:
			bullet.rotation_degrees = 180
			bullet.velocity.x = bullet.speed * delta


func change_type_bullet():
	if Input.is_action_just_pressed("change_type_bullet"):
		is_normal_bullet = !is_normal_bullet
		sacredEffect.visible = !is_normal_bullet


func death():
	get_tree().reload_current_scene()


func _on_timerParticle_timeout():
	particles.emitting = false


func _on_Sword_body_entered(body):
	if body.has_method("take_sword_damage"):
		body.take_sword_damage(sword_damage)


func _on_HitArea_body_entered(body):
	if body.is_in_group('thorns'):
		thorns = body
		thorns_damage_player()
		

func thorns_damage_player():
	if thorns != null and $HitArea.overlaps_body(thorns) and not cooldown_hit:
		var chosen = (randi() % $damage_sound.get_child_count()) + 1
		get_node("damage_sound/damage-" + str(chosen)).play()
		$CooldownHit.start()
		cooldown_hit = true
		life -= 10

func _on_CooldownHit_timeout():
	cooldown_hit = false
