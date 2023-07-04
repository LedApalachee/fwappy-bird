extends Node2D

export(float) var scrolling_speed = 100
export(float) var destoying_distance = -100
export(float) var gap = 74

signal point_captured
signal bird_bumped


func _ready():
	$upper_tube.position.y = gap / (-2)
	$lower_tube.position.y = gap / 2



func _physics_process(dt):
	if position.x < destoying_distance:
		queue_free()
	position.x -= scrolling_speed * dt



func _on_pointbox_body_entered(body):
	$pointbox/collision_shape_2d.set_deferred("disabled", true)
	emit_signal("point_captured")



func _on_upper_hitbox_body_entered(body):
	$pointbox/collision_shape_2d.set_deferred("disabled", true)
	emit_signal("bird_bumped")

func _on_lower_hitbox_body_entered(body):
	$pointbox/collision_shape_2d.set_deferred("disabled", true)
	emit_signal("bird_bumped")
