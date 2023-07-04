extends StaticBody2D

export var fill_ratio = 0.2 # which part of screen it occupies
export var scrolling_speed = 100
export var segment_scale = 1

var FLOOR_SEGMENT_SPRITE_WIDTH
var FLOOR_SEGMENT_SPRITE_HEIGHT

var floor_segment_texture = preload("res://assets/floor/floor_head.png")
var last_segment_end_x = 0


signal bird_bumped


func reset_position():
	$collision_shape_2d.shape.extents.x = get_viewport().size.x / 2
	$collision_shape_2d.shape.extents.y = get_viewport().size.y * fill_ratio / 2

	$hitbox/collision_shape_2d.shape.extents.x = get_viewport().size.x / 2
	$hitbox/collision_shape_2d.shape.extents.y = get_viewport().size.y * fill_ratio / 2 + 5

	$floor_fill.scale.x = get_viewport().size.x / 32
	$floor_fill.scale.y = get_viewport().size.y * fill_ratio / 32

	position.x = get_viewport().size.x / 2
	position.y = get_viewport().size.y - ( get_viewport().size.y * fill_ratio / 2 )

	$segments.global_position.x = 0
	$segments.position.y = -get_viewport().size.y * fill_ratio / 2
	init_segments()



func init_segments():
	var new_sprite
	while last_segment_end_x < get_viewport().size.x + 2 * FLOOR_SEGMENT_SPRITE_WIDTH * segment_scale:
		new_sprite = Sprite.new()
		new_sprite.texture = floor_segment_texture
		new_sprite.position.x = last_segment_end_x
		new_sprite.position.y = FLOOR_SEGMENT_SPRITE_HEIGHT * segment_scale / 2
		new_sprite.scale.x = segment_scale
		new_sprite.scale.y = segment_scale
		$segments.add_child(new_sprite)
		last_segment_end_x += FLOOR_SEGMENT_SPRITE_WIDTH * segment_scale



func _ready():
	get_viewport().connect("size_changed", self, "_on_viewport_size_changed")
	var temp_sprite = Sprite.new()
	temp_sprite.texture = floor_segment_texture
	FLOOR_SEGMENT_SPRITE_WIDTH = temp_sprite.get_rect().size.x
	FLOOR_SEGMENT_SPRITE_HEIGHT = temp_sprite.get_rect().size.y
	temp_sprite.queue_free()
	reset_position()



func _physics_process(dt):
	for segment in $segments.get_children():
		segment.position.x -= scrolling_speed * dt
	last_segment_end_x -= scrolling_speed * dt

	if $segments.get_child(0).position.x + FLOOR_SEGMENT_SPRITE_WIDTH * segment_scale < 0:
		$segments.get_child(0).position.x = last_segment_end_x
		$segments.move_child($segments.get_child(0), $segments.get_child_count())
		last_segment_end_x += FLOOR_SEGMENT_SPRITE_WIDTH * segment_scale



func _on_viewport_size_changed():
	reset_position()



func _on_hitbox_body_entered(body):
	emit_signal("bird_bumped")
