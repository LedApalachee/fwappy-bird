extends Node

var score_file = File.new()
var no_score_file = false
var bird_bodies = []
var bird_bodies_choice = RandomNumberGenerator.new()

enum GameState { NONE, AT_START_SCREEN, AT_PLAYING, AT_GAME_OVER }
var current_state = GameState.AT_PLAYING

var count = 0
var max_count
var new_score: bool



func list_files(directory):
	var files = []
	var dir = Directory.new()
	dir.open(directory)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append((directory + "/" + file).trim_suffix(".import"))

	dir.list_dir_end()
	return files



func load_bird_bodies():
	for path in list_files("res://assets/bodies"):
		bird_bodies.append(load(path))
	bird_bodies_choice.randomize()



func load_score():
	if not score_file.file_exists("user://score.save"):
		max_count = 0
	else:
		score_file.open("user://score.save", File.READ)
		max_count = score_file.get_32()
		score_file.close()
	$ui/game_over/old_score_label.text = "Max count: " + str(max_count)


func save_score():
	score_file.open("user://score.save", File.WRITE)
	score_file.store_32(max_count)
	score_file.close()



func new_run():
	new_score = false
	$world.create_bird( bird_bodies[ bird_bodies_choice.randi_range(0, len(bird_bodies) - 1) ])
	$world.create_obstacle(get_viewport().size.x + 800, get_viewport().size.y * (1 - $world/floor.fill_ratio) / 2)
	$world.enable_scrolling()



func _ready():
	load_score()
	load_bird_bodies()
	$background.position.y = get_viewport().size.y * (1 - $world/floor.fill_ratio)
	$background.position.x = get_viewport().size.x / 2
	new_run()
	$ui/color_rect.start_opening()



func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed and $no_input_timer.time_left <= 0:
			match current_state:

				GameState.AT_GAME_OVER:
						$world.clear()
						new_run()
						current_state = GameState.AT_PLAYING
						$ui/game_over.visible = false
						count = 0



func _physics_process(delta):
	$ui/count_label.text = str(count)
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()



func _on_world_game_over():
	current_state = GameState.AT_GAME_OVER
	$ui/animation_player.play("game_over")
	if new_score:
		$ui/game_over/you_hit_the_score.visible = true
		$ui/game_over/old_score_label.visible = false
	else:
		$ui/game_over/you_hit_the_score.visible = false
		$ui/game_over/old_score_label.visible = true
	$no_input_timer.start()


func _on_world_point_captured():
	count += 1
	if count > max_count:
		new_score = true
		max_count = count
		$ui/game_over/old_score_label.text = "Max count: " + str(max_count)
		save_score()
