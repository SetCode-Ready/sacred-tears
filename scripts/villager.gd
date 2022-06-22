extends KinematicBody2D

const ACCELERATION = 512
const MAX_SPEED = 320
const FRICTION = 1
const GRAVITY = 2000
var motion = Vector2.ZERO

var is_right = true
var direction_valuant = 1

enum {OLDMAN, MAN, OLDWOMAN, WOMAN, BOY, GIRL}

#NAME  ,  POSITION.Y   SCALE.Y
var list_animation = {
	0:['OLDMAN', -1, 1.3], 
	1:['MAN', -4, 1.4], 
	2:['OLDWOMAN', -1, 1.3], 
	3:['WOMAN', -4, 1.4], 
	4:['BOY', 14, 1], 
	5:['GIRL', 14, 1] 
}

func _ready():
	var rng = RandomNumberGenerator.new();
	rng.randomize();
	var num = rng.randi_range(0, 5)
	$FireParticlesBack.position.y = -19 if num > 3 else -54
	
	$Sprite.play(list_animation[num][0])
	$Colision.position.y = list_animation[num][1]
	$Colision.scale.y = list_animation[num][2]




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $RayCastR.is_colliding():
		is_right = false
	if $RayCastL.is_colliding():
		is_right = true
	
	if is_right:
		$Sprite.position.x = 26
		$Sprite.flip_h = false
	else:
		$Sprite.position.x = -55
		$Sprite.flip_h = true

	
	direction_valuant = 1 if is_right else -1
	motion.x += ACCELERATION * direction_valuant
	motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
	
	motion.y += GRAVITY * delta
	motion = move_and_slide(motion, Vector2.UP)
