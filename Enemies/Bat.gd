extends KinematicBody2D

export var FRICTION = 20
export var KNOCKBACK_STRENGTH = 50
const HitEffect = preload("res://Effects/HitEffect.tscn")
const DeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

onready var animation = $AnimatedSprite
onready var stats = $Stats

var velocity = Vector2.ZERO

func _ready():
	animation.play("default")
	
func create_hit_effect():
	var hitEffect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(hitEffect)
	hitEffect.global_position = global_position - Vector2(0, 12)
	
func create_death_effect():
	var deathEffect = DeathEffect.instance()
	var parent = get_parent()
	parent.add_child(deathEffect)
	deathEffect.position = position - Vector2(0, 12)

func _physics_process(delta):
	velocity = move_and_slide(velocity)

func _process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)	

func _on_HurtBox_area_entered(area):
	velocity = area.knockback * KNOCKBACK_STRENGTH
	stats.health -= area.damage
	create_hit_effect()

func _on_Stats_no_health():
	create_death_effect()
	queue_free()
