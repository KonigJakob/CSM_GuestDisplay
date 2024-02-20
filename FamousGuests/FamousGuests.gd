extends Control

var tween : Tween
var guests = []
var visible_guests = []
var guest_portrait = preload("res://FamousGuests/guest_scene.tscn")

@export var portrait_position_start : Vector2
@export var portrait_gutter: float

@onready var portrait_panel = $Panel

var right_clicks : int
var left_clicks : int

func _ready():
	guests = load_guests()
	set_guest_positions(guests, $Panel)
	set_portrait_panel_position()
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

func set_portrait_panel_position():
	portrait_panel.position = get_viewport_rect().size/2 - portrait_panel.size/2

func set_guest_positions(guest_array : Array, parent):
	var current_x : int = 0
	for g in guest_array:
		#g.gloabl_position.y = parent.position.y
		g.position.x = current_x
		current_x += g.size.x + portrait_gutter
		parent.add_child(g)

func move_guests_right(g):
	tween.tween_property(g, "position", Vector2(g.position.x - g.size.x - portrait_gutter, g.position.y), 1)
	
func move_guests_left(g):
	tween.tween_property(g, "position", Vector2(g.position.x + g.size.x + portrait_gutter, g.position.y), 1)

func _on_timer_timeout():
	pass
	
func _on_guest_timer_timeout():
	pass
