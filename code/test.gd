extends Node


#func _ready():


func _physics_process(dt):
	if Input.is_action_just_pressed("test_enter"):
		add_child(Node.new())
		print(get_children())

	if Input.is_action_just_pressed("test_space"):
		move_child(get_child(0), get_child_count())
		print(get_children())
