extends Node2D

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		var GrassEffect = load("res://Effects/GrassEffect.tscn")
		var grassEffect = GrassEffect.instance()
		var parent = get_parent()
		parent.add_child(grassEffect)
		grassEffect.position = position
		queue_free()
