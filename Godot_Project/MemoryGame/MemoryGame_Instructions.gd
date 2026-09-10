extends Label

var timer 


# Called when the node enters the scene tree for the first time.
func _ready():
	timer = get_tree().create_timer(3)
	timer.timeout.connect(on_timer_timout)

func on_timer_timout():
	var tween = get_tree().create_tween()
	tween.set_loops(1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC)
	add_theme_font_size_override("font_size", 10)
