extends Area2D


var velocity = Vector2();
var speed = 400;
var is_normal = true
export var sacred_water_damage = 15
onready var sprite = get_node("sprite")
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_collision_layer_bit(5, true)
	set_collision_layer_bit(6, false)


func _physics_process(delta):
	if is_normal:
		sprite.play("normal")
		set_collision_layer_bit(5, true)
		set_collision_layer_bit(6, false)
	else:
		sprite.play("sacred")
		set_collision_layer_bit(5, false)
		set_collision_layer_bit(6, true)
	translate(velocity)
	

func _on_Bullet_body_entered(body):
	queue_free()


func _on_Bullet_area_entered(area):
	queue_free()
