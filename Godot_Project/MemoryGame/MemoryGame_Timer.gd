extends Label

var counting = false

var time_elapsed : float = 0
var count_time : bool = true

func _ready():
	count_time = false
	position = Vector2(get_viewport_rect().size.x/2 - size.x/2, 450)

func _process(delta):
	if count_time:
		time_elapsed += delta
		text = "%.1f" % time_elapsed
	
func restart_time():
	time_elapsed = 0
	text = str(time_elapsed)
	
func start_stopwatch():
	if !count_time:
		count_time = true

func stop_stopwatch():
	count_time = false

func animate_lable():
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	tween.tween_property(self,"theme_override_font_sizes/font_size", 200, 0.5)
	tween.tween_property(self,"theme_override_font_sizes/font_size", 150, 0.1)
	
func _on_memory_game_successful_sequence():
	stop_stopwatch()
	animate_lable()

func _on_memory_game_game_started():
	start_stopwatch()

func _on_button_styled_child_button_pressed():
	stop_stopwatch()
	restart_time()
