extends Control

var tween : Tween
var guests = []
var visible_guests = []
var guest_portrait = preload("res://FamousGuests/guest_scene.tscn")

var viewport

@export var input_lock_rect : ColorRect
@export var panel_input_lock : ColorRect
@export var portrait_gutter: float
@export var tween_duration: float = 1

@export var portrait_panel : Panel
@export var left_arrow : button_syled
@export var left_arrow_sub : button_syled
@export var right_arrow : button_syled
@export var right_arrow_sub : button_syled
@export var localization_buttons : HBoxContainer
@export var home_button: button_syled
@export var logo : TextureRect
@export var titel : CenterContainer
@export var timer : Timer

var right_clicks : int
var left_clicks : int
var move_right : bool

func _ready():
	guests = SaveSystem.guest_array
	viewport = get_viewport_rect().size
	connect_guest_signal()
	set_guest_positions(SaveSystem.guest_array, portrait_panel)
	set_ui_elements_transform()
	right_clicks = 0
	left_clicks = SaveSystem.guest_array.size() -1
	for g in SaveSystem.guest_array:
		g.info_panel.update_guest_properties()
	panel_input_lock.visible = false

func _input(event):
	if event is InputEventMouseButton:
		timer.start(timer.wait_time)

func set_ui_elements_transform():
	portrait_panel.position = viewport / 2 - (portrait_panel.size / 2) + Vector2(0, 100)
	left_arrow.position = Vector2(35, portrait_panel.position.y + portrait_panel.size.y + left_arrow.size.y * 1.5)
	right_arrow.position = Vector2(viewport.x - right_arrow.size.x - 35, left_arrow.position.y)
	right_arrow_sub.position = Vector2(viewport.x - right_arrow_sub.size.x, portrait_panel.position.y - 100)
	left_arrow_sub.position = Vector2(0, portrait_panel.position.y - 100)
	localization_buttons.position = Vector2(viewport.x - localization_buttons.size.x - 35, viewport.y - localization_buttons.size.y - 35)
	home_button.position = Vector2(viewport.x/2 - home_button.size.x/2, viewport.y - home_button.size.y * 2)
	logo.position = Vector2(get_viewport_rect().size.x/2 - logo.size.x/2, 100)
	titel.position = Vector2(0,logo.position.y + logo.size.y + 70)

func connect_guest_signal():
	for g in SaveSystem.guest_array:
		g.info_panel_changed.connect(_on_info_panel_changed)

func set_guest_positions(guest_array : Array, parent):
	var current_x : int = 0
	guest_array.shuffle()
	for g in guest_array:
		#g.gloabl_position.y = parent.position.y
		g.position.x = current_x
		current_x += g.size.x + portrait_gutter
		parent.add_child(g)

func move_guests_right(g):
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(g, "position", Vector2(g.position.x - g.size.x - portrait_gutter, g.position.y), tween_duration)
	
func move_guests_left(g):
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(g, "position", Vector2(g.position.x + g.size.x + portrait_gutter, g.position.y), tween_duration)

func _on_button_home_pressed():
	SceneManager.reparent_guests()
	SceneManager.target_scene = "res://MainMenu/main.tscn"
	get_tree().change_scene_to_file("res://UI_Details/LoadingScene.tscn")

func _on_button_left_arrow_pressed():
	if right_clicks > 0:
		left_arrow.get_node("Button").disabled = true
		tween = get_tree().create_tween().set_parallel(true)
		tween.finished.connect(on_tween_finished)
		input_lock_rect.visible = true
		for g in SaveSystem.guest_array:
			move_guests_left(g)
		right_clicks -= 1
		left_clicks += 1

func _on_button_right_arrow_pressed():
	if left_clicks > 0:
		right_arrow.get_node("Button").disabled = true
		tween = get_tree().create_tween().set_parallel(true)
		input_lock_rect.visible = true
		tween.finished.connect(on_tween_finished)
		for g in SaveSystem.guest_array:
			move_guests_right(g)
		right_clicks += 1
		left_clicks -= 1
		
func on_tween_finished():
	left_arrow.get_node("Button").disabled = false
	right_arrow.get_node("Button").disabled = false
	input_lock_rect.visible = false

func _on_translation_de_child_button_pressed():
	SceneManager.set_language("de")

func _on_translation_en_child_button_pressed():
	SceneManager.set_language("en")
	
func _on_info_panel_changed(_value):
	if _value:
		timer.stop()
	else:
		timer.start(timer.wait_time)
	if panel_input_lock.visible == true:
		panel_input_lock.visible = false
	else:
		panel_input_lock.visible = true

func _on_timer_timeout():
	if panel_input_lock.visible == false:
		if move_right:
			if left_clicks > 0:
				right_arrow.get_node("Button").disabled = true
				tween = get_tree().create_tween().set_parallel(true)
				input_lock_rect.visible = true
				tween.finished.connect(on_tween_finished)
				for g in SaveSystem.guest_array:
					move_guests_right(g)
				right_clicks += 1
				left_clicks -= 1
				timer.start(timer.wait_time)
			else:
				move_right = false
		else:
			if right_clicks > 0:
				left_arrow.get_node("Button").disabled = true
				tween = get_tree().create_tween().set_parallel(true)
				tween.finished.connect(on_tween_finished)
				input_lock_rect.visible = true
				for g in SaveSystem.guest_array:
					move_guests_left(g)
				right_clicks -= 1
				left_clicks += 1
				timer.start(timer.wait_time)
			else:
				move_right = true
	else:
		timer.start(timer.wait_time)
