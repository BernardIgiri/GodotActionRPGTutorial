extends KinematicBody2D

export var FRICTION = 275
const HitEffect = preload("res://Effects/HitEffect.tscn")
const DeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

onready var stats = $Stats

var velocity = Vector2.ZERO

func positionEffect(effect):
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

func create_hit_effect():
	var effect = HitEffect.instance()
	positionEffect(effect)
	
func create_death_effect():
	var effect = DeathEffect.instance()
	positionEffect(effect)

func _physics_process(delta):
	velocity = move_and_slide(velocity)


func recovery_state(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)	

func _on_HurtBox_area_entered(area):
	velocity = area.knockback / stats.mass
	stats.health -= area.damage
	create_hit_effect()

func _on_Stats_no_health():
	create_death_effect()
	queue_free()
