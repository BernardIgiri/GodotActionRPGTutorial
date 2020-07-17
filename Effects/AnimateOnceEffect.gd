extends AnimatedSprite

func _ready():
	frame = 0
	play("default")
	connect("animation_finished", self, "_on_animation_finished")

func _on_animation_finished():
	queue_free()
