extends Node2D

func create_grass_effect():
	var GrassEffect = load("res://Effects/GrassEffect.tscn")
	var grassEffect = GrassEffect.instance()
	var parent = get_parent()
	parent.add_child(grassEffect)
	grassEffect.position = position

func _on_HurtBox_area_entered(area):
	create_grass_effect()
	queue_free()
