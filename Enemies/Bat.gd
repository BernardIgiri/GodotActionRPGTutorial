extends "res://Enemies/EnemyBody.gd"
var AI = load("res://AI/EnemyAI.gd")

onready var animation = $AnimatedSprite

func _process(delta):
	._process(delta)
	animation.flip_h = velocity.x < 0

func get_position():
	return 

func _ready():
	ai = AI.new(self)
	animation.play("default")

func positionEffect(effect):
	.positionEffect(effect)
	effect.global_position = global_position - Vector2(0, 12)
