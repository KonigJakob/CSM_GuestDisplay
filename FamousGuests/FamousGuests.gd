extends Control

var tween : Tween
var guests = []
var visible_guests = []
var guest_portrait = preload("res://FamousGuests/guest_scene.tscn")

@export var portrait_position_start : Vector2
@export var portrait_gutter: float

var current_portrait = 1

func _ready():
	guests = load_guests()
	carousel_guests()
	print(visible_guests)
	set_guest_positions(visible_guests, $Panel)

func _process(delta):
	if Input.is_action_just_pressed("move_right"):
		tween = get_tree().create_tween().set_parallel(true)
		for g in visible_guests:
			move_guests_left(g)
	if Input.is_action_just_pressed("move_left"):
		tween = get_tree().create_tween().set_parallel(true)
		for g in visible_guests:
			move_guests_right(g)

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
		print("Guests loaded")
	else: 
		print("Couldn't load guests.")
	return loaded_guests

func set_guest_positions(guest_array : Array, parent):
	print("Setting position")
	var current_x : int = 0
	for g in guest_array:
		#g.gloabl_position.y = parent.position.y
		g.position.x = current_x
		current_x += g.size.x + portrait_gutter
		if g.position.x == parent.position.x:
			current_portrait = g

func carousel_guests():
	for i in 5:
		var new_visible_guest = guests.pop_front()
		visible_guests.append(new_visible_guest)
		#You need to add the children at some point but not necessarily here. Good luck! Love you :
		#$Panel.add_child(new_visible_guest)

func move_guests_right(g):
	tween.tween_property(g, "position", Vector2(g.position.x - g.size.x - portrait_gutter, g.position.y), 1)
	
func move_guests_left(g):
	tween.tween_property(g, "position", Vector2(g.position.x + g.size.x + portrait_gutter, g.position.y), 1)

func _on_timer_timeout():
	pass
	
func _on_guest_timer_timeout():
	pass
