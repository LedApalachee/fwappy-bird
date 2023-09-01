extends Control


export(float) var initial_black_screen_time = 1.0
export(float) var aftertap_black_screen_time = 0.2

export(float) var global_scale_value = 1


enum StartScreenState {
NONE,
INITIAL_BLACK_SCREEN,
INITIAL_OPENING,
WAITING_FOR_TAP,
AFTERTAP_FADING,
AFTERTAP_BLACK_SCREEN,
AFTERTAP_OPENING
}

var cur_state = StartScreenState.INITIAL_BLACK_SCREEN

var timer = 0.0

var tapped = false
var button_pressed = false


func _ready():
	to_scale()
	$background.position.x = get_viewport().size.x / 2
	$background.position.y = get_viewport().size.y * (1 - $floor.fill_ratio)



func _physics_process(delta):
	match cur_state:
		
		StartScreenState.INITIAL_BLACK_SCREEN:
			if timer < initial_black_screen_time:
				$color_rect.color.a = 1.0
				timer += delta
			else:
				cur_state = StartScreenState.INITIAL_OPENING
				$color_rect.start_opening()
				timer = 0.0
			
		StartScreenState.WAITING_FOR_TAP:
			$color_rect.visible = false
			if tapped:
				$color_rect.visible = true
				cur_state = StartScreenState.AFTERTAP_FADING
				$color_rect.start_fading()
		
		StartScreenState.AFTERTAP_BLACK_SCREEN:
			if timer < aftertap_black_screen_time:
				$color_rect.color.a = 1.0
				timer += delta
			else:
				cur_state = StartScreenState.AFTERTAP_OPENING
				get_tree().change_scene("res://scenes/game.tscn")




func to_scale():
	$floor.scrolling_speed *= global_scale_value
	$floor.segment_scale *= global_scale_value
	$floor.reset_position()
	#
	$background.scale *= global_scale_value
	#
	$game_title.margin_left *= global_scale_value
	$game_title.margin_top *= global_scale_value
	$game_title.margin_right *= global_scale_value
	$game_title.margin_bottom *= global_scale_value
	#
	$game_title/fwappy.get_font("font").size *= global_scale_value
	$game_title/fwappy.get_font("font").outline_size *= global_scale_value
	#
	$game_title/bird.get_font("font").size *= global_scale_value
	$game_title/bird.get_font("font").outline_size *= global_scale_value
	#
	$tap_to_start_label.get_font("font").size *= global_scale_value
	$tap_to_start_label.get_font("font").outline_size *= global_scale_value
	#
	$h_box_container/author.get_font("font").size *= global_scale_value
	$h_box_container/author.get_font("font").outline_size *= global_scale_value
	#
	$h_box_container/reset_score_button.get_font("font").size *= global_scale_value
	$h_box_container/reset_score_button.get_font("font").outline_size *= global_scale_value




func _on_color_rect_fade_finished():
	cur_state = StartScreenState.AFTERTAP_BLACK_SCREEN


func _on_color_rect_open_finished():
	cur_state = StartScreenState.WAITING_FOR_TAP


func _on_reset_score_button_pressed():
	button_pressed = true
	var dir = Directory.new()
	dir.remove("user://score.save")


func _on_tap_area_pressed():
	tapped = true
