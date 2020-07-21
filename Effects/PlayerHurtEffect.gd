extends AudioStreamPlayer

func _on_PlayerHurtEffect_finished():
	queue_free()
