extends KinematicBody2D

const HitEffect = preload("res://Effects/HitEffect.tscn")
const DeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export var FRICTION = 275
export var SPEED = 50
export var ACCELERATION = 150
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
var ai = null
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

func _physics_process(_delta):
	velocity = move_and_slide(velocity)

func _process(delta):
	ai.update(delta)

func recover_motion(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	return velocity == Vector2.ZERO

func idle_motion(delta):
	recover_motion(delta)

func chase_motion(delta):
	var player = playerDetectionZone.player
	if player != null:
		var direction = (player.global_position - global_position).normalized()
		velocity = velocity.move_toward(direction * SPEED, ACCELERATION * delta)

func can_see_player():
	return playerDetectionZone.can_see_player()

func _on_HurtBox_area_entered(area):
	velocity = area.knockback / stats.mass
	stats.health -= area.damage
	create_hit_effect()
	ai.hit()

func _on_Stats_no_health():
	create_death_effect()
	queue_free()
