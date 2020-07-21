extends Area2D

onready var timer = $InvincibilityTimer
onready var collision_shape = $CollisionShape2D

func is_invicible():
	return collision_shape.disabled

func _on_InvincibilityTimer_timeout():
	collision_shape.set_deferred("disabled", false)

func _on_HurtBox_area_entered(_area):
	if !is_invicible():
		collision_shape.set_deferred("disabled", true);
		timer.start()
