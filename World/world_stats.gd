extends Node

var enemy_count = 0 setget set_enemy_count

signal no_enemies

func set_enemy_count(value):
	enemy_count = value
	if value < 1:
		enemy_count = 0
		emit_signal("no_enemies")
	
