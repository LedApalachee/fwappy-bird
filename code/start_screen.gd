extends Control


export(float) var initial_black_screen_time = 1.0
export(float) var initial_opening_time = 1.0
export(float) var aftertap_fading_time = 1.0
export(float) var aftertap_black_screen_time = 0.2
export(float) var aftertap_opening_time = 1.0


enum StartScreenState {
NONE,
INITIAL_BLACK_SCREEN,
INITIAL_OPENING,
WAITING_FOR_TAP,
AFTERTAP_FADING,
AFTERTAP_BLACK_SCREEN,
AFTERTAP_OPENING
}

var prev_state = StartScreenState.NONE
var cur_state = StartScreenState.INITIAL_BLACK_SCREEN

var timer = 0.0

var tapped = false


func _ready():
	$background.position.x = get_viewport().size.x / 2
	$background.position.y = get_viewport().size.y * (1 - $floor.fill_ratio)


func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			tapped = true


func _physics_process(delta):
	match cur_state:
		
		StartScreenState.INITIAL_BLACK_SCREEN:
			if timer < initial_black_screen_time:
				$color_rect.color.a = 1.0
				timer += delta
				prev_state = cur_state
			else:
				prev_state = cur_state
				cur_state = StartScreenState.INITIAL_OPENING
				$color_rect.start_opening()
				timer = 0.0
			
		StartScreenState.WAITING_FOR_TAP:
			if tapped:
				prev_state = cur_state
				cur_state = StartScreenState.AFTERTAP_FADING
				$color_rect.start_fading()
		
		StartScreenState.AFTERTAP_BLACK_SCREEN:
			if timer < aftertap_black_screen_time:
				$color_rect.color.a = 1.0
				timer += delta
				prev_state = cur_state
			else:
				prev_state = cur_state
				cur_state = StartScreenState.AFTERTAP_OPENING
				get_tree().change_scene("res://scenes/game.tscn")


func _on_color_rect_fade_finished():
	prev_state = cur_state
	cur_state = StartScreenState.AFTERTAP_BLACK_SCREEN


func _on_color_rect_open_finished():
	match cur_state:
		
		StartScreenState.INITIAL_OPENING:
			prev_state = cur_state
			cur_state = StartScreenState.WAITING_FOR_TAP
