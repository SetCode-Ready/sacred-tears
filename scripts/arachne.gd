extends KinematicBody2D


const GRAVITY = 2000
const ACCELERETION = 100

var motion = Vector2.ZERO

var is_moving_left = false

var is_attacking = false

func _ready():
	start_walk()
	

func _process(delta):
	if is_attacking:
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


func start_walk():
	$Sprite.play("Walk")


func _on_PlayerDetector_body_entered(body):
	$Sprite.play("Attack")
	is_attacking = true


func _on_AttackDetector_body_entered(body):
	pass


func _on_Sprite_animation_finished():
	if $Sprite.animation == "Attack":
		is_attacking = false
