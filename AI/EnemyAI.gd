enum {
	IDLE,
	RECOVER,
	CHASE
}

var state = IDLE
var enemy = null

func _init(enemy = null):
	self.enemy = enemy

func update(delta):
	match state:
		IDLE:
			idle_state(delta)
		RECOVER:
			recover_state(delta)
		CHASE:
			chase_state(delta)

func idle_state(delta):
	enemy.idle_motion(delta)
	if enemy.can_see_player():
		state = CHASE

func recover_state(delta):
	if !enemy.recover_motion(delta):
		state = IDLE

func chase_state(delta):
	enemy.chase_motion(delta)
	if !enemy.can_see_player():
		state = RECOVER

func hit():
	state = RECOVER
