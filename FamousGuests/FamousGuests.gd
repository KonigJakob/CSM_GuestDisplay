extends Control

var tween : Tween
var guests = []
var visible_guests = []
var guest_portrait = preload("res://FamousGuests/guest_scene.tscn")

var viewport

@export var input_lock_rect : ColorRect
@export var panel_input_lock : ColorRect
@export var portrait_gutter: float

@export var portrait_panel : Panel
@export var left_arrow : button_syled
@export var right_arrow : button_syled
@export var localization_buttons : HBoxContainer
@export var home_button: button_syled
@export var logo
@export var timer : Timer

var right_clicks : int
var left_clicks : int
var move_right : bool

func _ready():
	viewport = get_viewport_rect().size
	guests = load_guests()
	set_guest_positions(guests, portrait_panel)
	set_ui_elements_transform()
	right_clicks = 0
	left_clicks = guests.size() -1

func _input(event):
	if event is InputEventMouseButton:
		print("restart timer")
		timer.start(timer.wait_time)

func set_ui_elements_transform():
	portrait_panel.position = viewport / 2 - (portrait_panel.size / 2)
	left_arrow.position = Vector2(35, portrait_panel.position.y + portrait_panel.size.y + left_arrow.size.y * 1.5)
	right_arrow.position = Vector2(viewport.x - right_arrow.size.x - 35, left_arrow.position.y)
	localization_buttons.position = Vector2(viewport.x - localization_buttons.size.x - 35, viewport.y - localization_buttons.size.y - 35)
	home_button.position = Vector2(35, viewport.y - home_button.size.y - 35)
	logo.position = Vector2(get_viewport_rect().size.x/2 - logo.size.x/2, 100)
	
func load_guests() -> Array:
	#var guests_w_images
	var loaded_guests = []
	#Load guests info, instantiate the scenes and save them in an array
	if SaveSystem.load_guest():
		guests = SaveSystem.load_guest()
		#guests_w_images = SaveSystem.assign_images(guests)
		for g in guests:
			var _guest_portrait = guest_portrait.instantiate()
			_guest_portrait.guest_name = guests[g]["Name"]
			_guest_portrait.country = guests[g]["Country"]
			_guest_portrait.birth = guests[g]["Birth"]
			_guest_portrait.famous_for = guests[g]["Famous for"]
			_guest_portrait.image_1 = guests[g]["Image 1"]
			_guest_portrait.image_2 = guests[g]["Image 2"]
			_guest_portrait.image_3 = guests[g]["Image 3"]
			_guest_portrait.portrait = guests[g]["Portrait"]
			_guest_portrait.update_guest_info()
			_guest_portrait.info_panel_changed.connect(_on_info_panel_changed)
			loaded_guests.append(_guest_portrait)
			SaveSystem.number_of_guests += 1
			
	else: 
		print("Couldn't load guests.")
	return loaded_guests

func set_guest_positions(guest_array : Array, parent):
	var current_x : int = 0
	for g in guest_array:
		#g.gloabl_position.y = parent.position.y
		g.position.x = current_x
		current_x += g.size.x + portrait_gutter
		parent.add_child(g)

func move_guests_right(g):
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(g, "position", Vector2(g.position.x - g.size.x - portrait_gutter, g.position.y), 1)
	
func move_guests_left(g):
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(g, "position", Vector2(g.position.x + g.size.x + portrait_gutter, g.position.y), 1)

func _on_button_home_pressed():
	SceneManager.target_scene = "res://MainMenu/main.tscn"
	get_tree().change_scene_to_file("res://UI_Details/LoadingScene.tscn")

func _on_button_left_arrow_pressed():
	if right_clicks > 0:
		left_arrow.get_node("Button").disabled = true
		tween = get_tree().create_tween().set_parallel(true)
		tween.finished.connect(on_tween_finished)
		input_lock_rect.visible = true
		for g in guests:
			move_guests_left(g)
		right_clicks -= 1
		left_clicks += 1

func _on_button_right_arrow_pressed():
	if left_clicks > 0:
		right_arrow.get_node("Button").disabled = true
		tween = get_tree().create_tween().set_parallel(true)
		input_lock_rect.visible = true
		tween.finished.connect(on_tween_finished)
		for g in guests:
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
	pass
	if move_right:
		if left_clicks > 0:
			right_arrow.get_node("Button").disabled = true
			tween = get_tree().create_tween().set_parallel(true)
			input_lock_rect.visible = true
			tween.finished.connect(on_tween_finished)
			for g in guests:
				move_guests_right(g)
			right_clicks += 1
			left_clicks -= 1
		else:
			move_right = false
	else:
		if right_clicks > 0:
			left_arrow.get_node("Button").disabled = true
			tween = get_tree().create_tween().set_parallel(true)
			tween.finished.connect(on_tween_finished)
			input_lock_rect.visible = true
			for g in guests:
				move_guests_left(g)
			right_clicks -= 1
			left_clicks += 1
		else:
			move_right = true
