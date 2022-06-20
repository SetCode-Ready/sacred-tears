extends KinematicBody2D

onready var sprite = get_node("Sprite")
onready var particles = get_node("jetpackParticles")
onready var initial_scale = scale

const ACCELERATION = 512
const MAX_SPEED = 320
const FRICTION = 1
const GRAVITY = 2000
const JUMP_FORCE = 700

var motion = Vector2.ZERO

var did_first_jump = false

var is_attacking = false

var is_moving_left = false


func _physics_process(delta):
	
	player_move(delta)
	
	detect_turn_around()
	
	play_jump_animation()
	
	player_attack()
	

func player_move(delta):
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") 
	
	if x_input != 0:
		if not is_attacking:
			sprite.play("Run")
		motion.x += x_input * ACCELERATION
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		if x_input > 0:
			is_moving_left = false
			particles.position.x = -10 
		else:
			is_moving_left = true
			particles.position.x = 14
#		sprite.flip_h = x_input < 0
	else:
		if not is_attacking:
			sprite.play("Idle")
		motion.x = lerp(motion.x, 0, FRICTION)
		
	motion.y += GRAVITY * delta
	
	player_jump()
	
	motion = move_and_slide(motion, Vector2.UP)


func player_jump():
	if Input.is_action_just_released("ui_accept"):
		if did_first_jump == false and not is_on_floor():
			did_first_jump = true
		particles.emitting = false
			
	if Input.is_action_pressed("ui_accept"):
		if is_on_floor():
			did_first_jump = false
			motion.y = -JUMP_FORCE
			
		if did_first_jump == true and not is_on_floor():
			motion.y = -JUMP_FORCE
			particles.emitting = true


func play_jump_animation():
	if not is_on_floor():
		if not is_attacking:
			sprite.play("Jump")


func detect_turn_around():
	$Sprite.scale.x = (-1 if is_moving_left else 1)
	$PlayerCollisionShape.position.x = (8 if is_moving_left else 0)
	

func player_attack():
	if Input.is_action_just_pressed("left_click") :
		sprite.play("Attack")
		is_attacking = true
		

func _on_Sprite_animation_finished():
	if sprite.animation == "Attack":
		is_attacking = false
