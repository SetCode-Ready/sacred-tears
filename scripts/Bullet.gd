extends Area2D


var velocity = Vector2();
var speed = 400;
var is_normal = true
onready var sprite = get_node("sprite")
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if is_normal:
		sprite.play("normal")
	else:
		sprite.play("sacred")
	translate(velocity)



func _on_Bullet_body_entered(body):
	queue_free()
