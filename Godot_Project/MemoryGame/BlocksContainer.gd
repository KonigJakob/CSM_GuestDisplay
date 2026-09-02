extends GridContainer

var children: Array
var color_rects: Array
var color_of_squares: Color

var color_tween

func _ready():
	position = Vector2(get_viewport_rect().size.x/2 - size.x/2, get_viewport_rect().size.y/2 - size.y/2)
	grow_horizontal = Control.GROW_DIRECTION_BOTH
	grow_vertical = Control.GROW_DIRECTION_BOTH
	pass

func set_grid_columns(number_of_squares) -> void:
	match number_of_squares:
		1:
			columns = 1
		4:
			columns = 2
		9:
			columns = 3
		16:
			columns = 4
		_:
			columns = 1
			print("Check number of squares.")
	pass
	
func get_color_rects() -> Array:
	var rects: Array
	for i in range(children.size()):
		if children[i].get_child(0) is ColorRect:
			rects.append(children[i].get_child(0))
		else:
			print("Not a Colorrect")
	return rects
	
func set_color_rects_scale(scale_x, scale_y):
	for r in range(color_rects.size()):
		color_rects[r].scale = Vector2(scale_x, scale_y)

func set_color_of_squares():
	color_of_squares = SaveSystem.block_colors.pick_random()
	for r in range(color_rects.size()):
		color_rects[r].color = color_of_squares
	pass
	
func animate_squares_intro():
	for r in range(color_rects.size()):
		await get_tree().create_timer(0.125).timeout
		var scale_tween = get_tree().create_tween()
		scale_tween.tween_property(color_rects[r], "scale", Vector2(1,1), 1)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)

func _on_memory_game_buttons_added():
	children = get_children()
	color_rects = get_color_rects()
	set_grid_columns(children.size())
	set_color_rects_scale(0,0)
	set_color_of_squares()
	animate_squares_intro()
	
func animate_square_out(cr : ColorRect):
	var scale_tween = get_tree().create_tween()
	scale_tween.tween_property(cr, "scale", Vector2(0,0), 1)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)

func animate_square_in(cr : ColorRect):
	var scale_tween = get_tree().create_tween()
	scale_tween.tween_property(cr, "scale", Vector2(1,1), 1)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)

func animate_squares_success():
	for r in range(color_rects.size()):
		await get_tree().create_timer(0.125).timeout
		var scale_tween = get_tree().create_tween()
		scale_tween.tween_property(color_rects[r], "scale", Vector2(1,1), 1)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		color_tween = get_tree().create_tween().set_loops(2)
		color_tween.set_ease(Tween.EASE_OUT_IN).set_trans(Tween.TRANS_SINE)
		for b in color_rects.size():
			color_tween.tween_property(color_rects[b], "color", SaveSystem.block_colors.pick_random(), 0.3)

func _on_memory_game_successful_sequence():
	animate_squares_success()
	pass


func _on_button_styled_child_button_pressed():
	if color_tween:
		color_tween.kill()
