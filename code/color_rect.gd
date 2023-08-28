extends ColorRect

signal fade_finished
signal open_finished


export(float) var fade_time = 1.0
export(float) var pre_fade_time = 1.0


enum ColorRectState {NONE, FADING, OPENING}
var cur_state = ColorRectState.NONE
var timer = 0.0


func start_fading():
	color.a = 0.0
	timer = 0.0
	cur_state = ColorRectState.FADING


func start_opening():
	color.a = 1.0
	timer = 0.0
	cur_state = ColorRectState.OPENING


func _process(delta):
	match cur_state:
		
		ColorRectState.FADING:
			if timer < fade_time:
				color.a = timer / fade_time
				timer += delta
			else:
				color.a = 1
				timer = 0.0
				cur_state = ColorRectState.NONE
				emit_signal("fade_finished")
		
		ColorRectState.OPENING:
			if timer < fade_time:
				color.a = (fade_time - timer) / fade_time
				timer += delta
			else:
				color.a = 0
				timer = 0.0
				cur_state = ColorRectState.NONE
				emit_signal("open_finished")
