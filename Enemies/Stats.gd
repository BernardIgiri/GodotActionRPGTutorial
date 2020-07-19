extends Node

export var max_health = 1
export var mass = 1

onready var health = max_health setget set_health

signal no_health
signal stats_changed

func set_health(value):
	if value != health:
		if (value < 1):
			health = 0
			emit_signal("no_health")
		else:
			health = value
		emit_signal("stats_changed", {
			"health": health,
			"max_health": max_health
		})
