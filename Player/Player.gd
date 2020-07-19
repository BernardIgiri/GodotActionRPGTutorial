extends KinematicBody2D

export var ACCELERATION = 300
export var MAX_VELOCITY = 100
export var ROLL_ACCELERATION = 800
export var ROLL_SPEED = 110
export var FRICTION = 275
export var START_DIRECTION = Vector2.LEFT

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var last_direction = START_DIRECTION
var stats = PlayerStats

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var sword = $HitBoxPivot/SwordHitBox

func _ready():
	stats.connect("no_health", self, "die")
	animationTree.active = true
	set_facing_vector(START_DIRECTION)

func set_facing_vector(direction):
	sword.knockback = direction * sword.knockback_strength
	last_direction = direction
	animationTree.set("parameters/Idle/blend_position", direction)
	animationTree.set("parameters/Run/blend_position", direction)
	animationTree.set("parameters/Attack/blend_position", direction)
	animationTree.set("parameters/Roll/blend_position", direction)

func die():
	queue_free()

func _process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)

func _physics_process(_delta):
	velocity = move_and_slide(velocity)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		set_facing_vector(input_vector)
		animationState.travel("Run")
		velocity += input_vector * ACCELERATION * delta
		velocity = velocity.clamped(MAX_VELOCITY)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	elif Input.is_action_just_pressed("roll"):
		state = ROLL

func attack_state(delta):
	animationState.travel("Attack")
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

func roll_state(delta):
	animationState.travel("Roll")
	velocity += last_direction * ROLL_ACCELERATION * delta
	velocity = velocity.clamped(ROLL_SPEED)

func attack_animation_finished():
	state = MOVE

func roll_animation_finished():
	state = MOVE

func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	velocity += area.knockback / stats.mass
	state = MOVE
