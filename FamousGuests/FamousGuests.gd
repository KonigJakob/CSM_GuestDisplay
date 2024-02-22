extends Control

var tween : Tween
var guests = []
var visible_guests = []
var guest_portrait = preload("res://FamousGuests/guest_scene.tscn")

@export var input_lock_rect : ColorRect
@export var portrait_position_start : Vector2
@export var portrait_gutter: float

@export var portrait_panel : Panel
@export var left_arrow : Button
@export var right_arrow : Button 

var right_clicks : int
var left_clicks : int

func _ready():
	guests = load_guests()
	set_guest_positions(guests, portrait_panel)
	set_ui_elements_transform()
	right_clicks = 0
	left_clicks = guests.size() -1

func _process(delta):
	if Input.is_action_just_pressed("move_right") and right_clicks > 0:
		tween = get_tree().create_tween().set_parallel(true)
		for g in guests:
			move_guests_left(g)
		right_clicks -= 1
		left_clicks += 1
	if Input.is_action_just_pressed("move_left") and left_clicks > 0:
		tween = get_tree().create_tween().set_parallel(true)
		for g in guests:
			move_guests_right(g)
		right_clicks += 1
		left_clicks -= 1

func set_ui_elements_transform():
	portrait_panel.position = get_viewport_rect().size / 2 - (portrait_panel.size / 2)
	left_arrow.position.y = portrait_panel.position.y
	right_arrow.position.y = portrait_panel.position.y
	left_arrow.size.y = portrait_panel.size.y
	right_arrow.size.y = portrait_panel.size.y
	
func load_guests() -> Array:
	var loaded_guests = []
	var guests = {}
	#Load guests info, instantiate the scenes and save them in an array
	if SaveSystem.load_guest():
		guests = SaveSystem.load_guest()
		for g in guests:
			var i = 1
			var _guest_portrait = guest_portrait.instantiate()
			_guest_portrait.guest_name = guests[g]["Name"]
			_guest_portrait.country = guests[g]["Country"]
			_guest_portrait.birth = guests[g]["Birth"]
			_guest_portrait.death = guests[g]["Death"]
			_guest_portrait.famous_for = guests[g]["Famous for"]
			_guest_portrait.image_1 = guests[g]["Image 1"]
			loaded_guests.append(_guest_portrait)
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
	get_tree().change_scene_to_file("res://MainMenu/main.tscn")

func _on_button_left_arrow_pressed():
	if right_clicks > 0:
		left_arrow.disabled = true
		tween = get_tree().create_tween().set_parallel(true)
		tween.finished.connect(on_tween_finished)
		input_lock_rect.visible = true
		for g in guests:
			move_guests_left(g)
		right_clicks -= 1
		left_clicks += 1

func _on_button_right_arrow_pressed():
	if left_clicks > 0:
		right_arrow.disabled = true
		tween = get_tree().create_tween().set_parallel(true)
		input_lock_rect.visible = true
		tween.finished.connect(on_tween_finished)
		for g in guests:
			move_guests_right(g)
		right_clicks += 1
		left_clicks -= 1
		
func on_tween_finished():
	left_arrow.disabled = false
	right_arrow.disabled = false
	input_lock_rect.visible = false
