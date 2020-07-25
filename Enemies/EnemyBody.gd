extends KinematicBody2D

const HitEffect = preload("res://Effects/HitEffect.tscn")
const DeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export var FRICTION = 275
export var SPEED = 50
export var ACCELERATION = 150
export var WANDER_RADIUS = 5
export var WANDER_SPEED = 20
export var WANDER_TARGET_RANGE = 4
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var softCollision = $SoftCollision
var ai = null
var velocity = Vector2.ZERO
var wander_vector = Vector2.ZERO
var target_position = Vector2.ZERO
var anchor_position = Vector2.ZERO
var collision = false

func _ready():
	anchor_position = global_position
	target_position = global_position
	get_node("/root/World").enemy_count = get_node("/root/World").enemy_count + 1

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
	var oldv = Vector2(velocity.x, velocity.y)
	velocity = move_and_slide(velocity)
	collision = oldv != velocity

func _process(delta):
	ai.update(delta)
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * SPEED

func recover_motion(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	return velocity == Vector2.ZERO

func idle_motion(delta):
	if collision || global_position.distance_to(target_position) <= WANDER_TARGET_RANGE:
		var x = rand_range(-WANDER_RADIUS, WANDER_RADIUS)
		var y = rand_range(-WANDER_RADIUS, WANDER_RADIUS)
		target_position = Vector2(x, y) + anchor_position
		wander_vector = (target_position - global_position).normalized() * WANDER_SPEED
	velocity = velocity.move_toward(wander_vector, FRICTION * delta)

func chase_motion(delta):
	var player = playerDetectionZone.player
	if player != null:
		var direction = (player.global_position - global_position).normalized()
		velocity = velocity.move_toward(direction * SPEED, ACCELERATION * delta)

func can_see_player():
	return playerDetectionZone.can_see_player()

func _on_HurtBox_area_entered(area):
	velocity += area.knockback / stats.mass
	stats.health -= area.damage
	create_hit_effect()
	ai.hit()

func _on_Stats_no_health():
	get_node("/root/World").enemy_count = get_node("/root/World").enemy_count - 1
	create_death_effect()
	queue_free()
