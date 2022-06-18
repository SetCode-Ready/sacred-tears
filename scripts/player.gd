extends KinematicBody2D

onready var sprite = get_node("Sprite")

const ACCELERATION = 512
const MAX_SPEED = 320
const FRICTION = 1
const GRAVITY = 2000
const JUMP_FORCE = 700

var motion = Vector2.ZERO

var did_first_jump = false

var is_attacking = false

func _physics_process(delta):
	
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") 
	
	if x_input != 0:
		if not is_attacking:
			sprite.play("Run")
		motion.x += x_input * ACCELERATION
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		sprite.flip_h = x_input < 0
	else:
		if not is_attacking:
			sprite.play("Idle")
		motion.x = lerp(motion.x, 0, FRICTION)
	
	motion.y += GRAVITY * delta
	
	if Input.is_action_just_released("ui_accept"):
		if did_first_jump == false and not is_on_floor():
			did_first_jump = true
			
	if Input.is_action_pressed("ui_accept"):
		if is_on_floor():
			did_first_jump = false
			motion.y = -JUMP_FORCE
		if did_first_jump == true and not is_on_floor():
			motion.y = -JUMP_FORCE
	
	motion = move_and_slide(motion, Vector2.UP)
	
	if not is_on_floor():
		if not is_attacking:
			sprite.play("Jump")
		
	if Input.is_action_just_pressed("left_click") :
		sprite.play("Attack")
		is_attacking = true


func _on_Sprite_animation_finished():
	if sprite.animation == "Attack":
		is_attacking = false
