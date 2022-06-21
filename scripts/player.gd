extends KinematicBody2D

onready var particles = get_node("JetpackParticles")
onready var bulletspawn = get_node("BulletSpawn")
onready var sacredEffect = get_node("SacredEffect")
onready var state_machine = $AnimationTree.get("parameters/playback")

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


func _ready():
	$AnimationTree.get("parameters/playback")

func _physics_process(delta):
	
	player_move(delta)
	
	detect_turn_around()
	
	player_attack()
	
	player_shoot(delta)
	
	change_type_bullet()


func player_move(delta):
	if is_on_floor():
		particles.emitting = false
	
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") 
	
	if x_input != 0:
		is_moving = true
		if not is_attacking or not is_shooting:
			state_machine.travel("Run")
		motion.x += x_input * ACCELERATION
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		bulletspawn.position.y = -15
		if x_input > 0:
			is_moving_left = false
			bulletspawn.position.x = 20
			particles.position.x = -10 
		else:
			is_moving_left = true
			bulletspawn.position.x = -15
			particles.position.x = 14
	else:
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
		
		if is_on_floor():
			can_double_jump = true
			motion.y = -JUMP_FORCE
			
		if not is_on_floor() and can_double_jump and Input.is_action_just_pressed("ui_accept"):
			particles.emitting = true
			motion.y = -JUMP_FORCE
			can_double_jump = false
		
		play_jump_animation()
		

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
	

func player_attack():
	if Input.is_action_just_pressed("left_click"):
		state_machine.travel("Attack")
		


func player_shoot(delta):
	# tecla z atira
	if Input.is_action_just_pressed("shoot"):
		is_shooting = true
		if not is_moving:
			state_machine.travel("IdleAttack")
		
		var bullet = bulletPath.instance()
		get_parent().add_child(bullet)
		
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

