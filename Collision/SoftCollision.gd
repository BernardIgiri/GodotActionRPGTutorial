extends Area2D

func is_colliding():
	var areas = get_overlapping_areas()
	return areas.size() > 0

func get_push_vector():
	if is_colliding():
		var area = get_overlapping_areas()[0]
		return area.global_position.direction_to(global_position).normalized()
	return Vector2.ZERO
