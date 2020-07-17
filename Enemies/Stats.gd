extends Node

export var max_health = 1
onready var health = max_health setget set_health

signal no_health

func set_health(value):
	if (value < 1):
		health = 0
		emit_signal("no_health")
	else:
		health = value
