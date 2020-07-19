extends Control

const HEART_WIDTH = 15
onready var empty_hearts = $EmptyHearts
onready var full_hearts = $FullHearts
var stats = PlayerStats

func _ready():
	set_stats(stats)
	stats.connect("stats_changed", self, "set_stats")

func set_stats(stats):
	empty_hearts.rect_size.x = stats.max_health * HEART_WIDTH
	full_hearts.rect_size.x = stats.health * HEART_WIDTH
	full_hearts.visible = stats.health > 0
