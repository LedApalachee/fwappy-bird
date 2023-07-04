extends Node

var bird_bodies = []
var bird_bodies_choice = RandomNumberGenerator.new()

enum GameState { NONE, AT_START_SCREEN, AT_PLAYING, AT_GAME_OVER }
var current_state = GameState.AT_START_SCREEN

var count = 0



func list_files(directory):
	var files = []
	var dir = Directory.new()
	dir.open(directory)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and not file.ends_with(".import"):
			files.append(directory + "/" + file)

	dir.list_dir_end()
	return files



func load_bird_bodies():
	for path in list_files("res://assets/bodies"):
		bird_bodies.append(load(path))
	bird_bodies_choice.randomize()



func new_run():
	$world.create_bird( bird_bodies[ bird_bodies_choice.randi_range(0, len(bird_bodies) - 1) ])
	$world.create_obstacle(get_viewport().size.x + 800, get_viewport().size.y * (1 - $world/floor.fill_ratio) / 2)
	$world.enable_scrolling()



func _ready():
	load_bird_bodies()



func _physics_process(dt):
	match current_state:

		GameState.AT_GAME_OVER:
			if Input.is_action_just_pressed("ui_accept"):
				$world.clear()
				new_run()
				current_state = GameState.AT_PLAYING

		GameState.AT_START_SCREEN:
			if Input.is_action_just_pressed("ui_accept"):
				new_run()
				current_state = GameState.AT_PLAYING



func _on_world_game_over():
	current_state = GameState.AT_GAME_OVER



func _on_world_point_captured():
	count += 1
	print(count)
