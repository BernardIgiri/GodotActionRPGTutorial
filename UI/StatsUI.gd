extends Control

const HEART_WIDTH = 15
onready var empty_hearts = $EmptyHearts
onready var full_hearts = $FullHearts
var stats = PlayerStats

func _ready():
	set_stats(stats)
	stats.connect("stats_changed", self, "set_stats")

func set_stats(statValues):
	empty_hearts.rect_size.x = statValues.max_health * HEART_WIDTH
	full_hearts.rect_size.x = statValues.health * HEART_WIDTH
	full_hearts.visible = statValues.health > 0
