extends "res://Enemies/Enemy.gd"

onready var animation = $AnimatedSprite

func _ready():
	animation.play("default")

func _process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

func positionEffect(effect):
	.positionEffect(effect)
	effect.global_position = global_position - Vector2(0, 12)
