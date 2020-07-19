extends Area2D

export var invicibility_timeout = 0.5
onready var timer = $InvincibilityTimer

func is_invicible():
	return !monitorable

func _on_InvincibilityTimer_timeout():
	set_deferred("monitorable", true)
	print("o")

func _on_HurtBox_area_entered(area):
	if monitorable:
		print("i")
		set_deferred("monitorable", false)
		timer.start(invicibility_timeout)
