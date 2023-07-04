extends Node2D


var ceil_scene = preload("res://scenes/ceil.tscn")
var obstacle_scene = preload("res://scenes/obstacle.tscn")
var bird_scene = preload("res://scenes/bird.tscn")


signal point_captured
signal game_over


func _ready():
	create_ceil()
	randomize()
	$obstacles.set_physics_process(false)
	$floor.set_physics_process(false)
	$obstacle_trigger.position.x = get_viewport().size.x
	#create_bird(load("res://assets/bodies/body-2.png"))
	#create_obstacle(get_viewport().size.x + 800, get_viewport().size.y * (1 - $floor.fill_ratio) / 2)



func enable_scrolling():
	$obstacles.set_physics_process(true)
	$floor.set_physics_process(true)



func create_ceil():
	var new_ceil = ceil_scene.instance()
	new_ceil.position.x = get_viewport().size.x / 2
	new_ceil.position.y = -20
	add_child(new_ceil)



func create_obstacle(pos_x, pos_y = -1):
	var new_obstacle = obstacle_scene.instance()
	new_obstacle.position.x = pos_x

	if pos_y < 0:
		var min_y = ($obstacles.gap/2) * $obstacles.obstacle_scale
		var max_y = get_viewport().size.y - ($obstacles.gap/2) * $obstacles.obstacle_scale - get_viewport().size.y * $floor.fill_ratio
		new_obstacle.position.y = (randi() % int(max_y - min_y + 1)) + min_y
	else:
		new_obstacle.position.y = pos_y

	new_obstacle.scale.x = $obstacles.obstacle_scale
	new_obstacle.scale.y = $obstacles.obstacle_scale

	new_obstacle.scrolling_speed = $obstacles.scrolling_speed
	new_obstacle.destoying_distance = $obstacles.destoying_distance
	new_obstacle.gap = $obstacles.gap
 
	new_obstacle.connect("point_captured", self, "_on_point_captured")
	new_obstacle.connect("bird_bumped", self, "_on_bird_bumped")
	$obstacles.call_deferred("add_child", new_obstacle)



func create_bird(texture):
	var new_bird = bird_scene.instance()
	new_bird.texture = texture
	new_bird.position.x = get_viewport().size.x / 5
	new_bird.position.y = get_viewport().size.y * (1 - $floor.fill_ratio) * 0.2

	new_bird.gravity = $bird_settings.gravity
	new_bird.flap_speed = $bird_settings.flap_speed
	new_bird.fall_speed_limit = $bird_settings.fall_speed_limit
	new_bird.rotation_speed = $bird_settings.rotation_speed
	new_bird.scale.x = $bird_settings.bird_scale
	new_bird.scale.y = $bird_settings.bird_scale

	add_child(new_bird)



func clear():
	for obstacle in $obstacles.get_children():
		obstacle.queue_free()
	$bird.queue_free()
	remove_child($bird)



func _on_point_captured():
	emit_signal("point_captured")



func _on_bird_bumped():
	$bird.is_alive = false
	$bird.fall_speed_limit *= 100
	$bird.gravity *= 2
	for obstacle in $obstacles.get_children():
		obstacle.scrolling_speed = 0
	$floor.set_physics_process(false)
	emit_signal("game_over")



func _on_obstacle_trigger_area_entered(area):
	create_obstacle($obstacle_trigger.position.x + $obstacles.obstacle_interval)