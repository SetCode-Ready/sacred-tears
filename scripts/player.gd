extends KinematicBody2D

onready var joystick = get_parent().get_node("Joystick/TouchScreenButton")

const ACCELERATION = 512
const MAX_SPEED = 64
const FRICTION = 0.25
const GRAVITY = 400
const JUMP_FORCE = 128

var motion = Vector2.ZERO

func _physics_process(delta):
	motion.y += GRAVITY * delta
	
#	move_and_slide(motion)


func _process(delta):
	move_and_slide(joystick.get_value() * 10)
