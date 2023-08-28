extends KinematicBody2D

var velocity = Vector2(0,0)

export(float) var gravity = 10
export(float) var flap_speed = 500
export(float) var fall_speed_limit = 500
export(float) var rotation_speed = 5
export(bool) var is_alive = true
export(Texture) var texture


func _ready():
	$body_sprite.texture = texture


#func input():
#	if Input.is_action_just_pressed("flap"):
#		velocity.y = -flap_speed - gravity
#		$animation_player.stop()
#		$animation_player.play("wing_flap")


func _input(event):
	if is_alive and event is InputEventScreenTouch:
		if event.pressed:
			velocity.y = -flap_speed - gravity
			$animation_player.stop()
			$animation_player.play("wing_flap")
			$flap_player.play()


func _physics_process(dt):
	velocity.y += gravity
	velocity.y = min(velocity.y, fall_speed_limit)
	var set_rotation = velocity.y * dt * rotation_speed
	set_rotation = max(set_rotation, -30)
	set_rotation = min(set_rotation, 45)
	rotation_degrees = set_rotation
	move_and_collide(velocity * dt)
