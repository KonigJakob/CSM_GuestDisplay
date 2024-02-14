extends Control

var rng = RandomNumberGenerator.new()
var chance : float = 0.5

var portraits : Array
var guests = {}
var loaded_guests = []
var guest_portrait = preload("res://FamousGuests/guest_scene.tscn")

@onready var grid = $GridContainer
var grid_blocks = []
var occupied_blocks = []
var max_occupied_blocks : int = 5
var shown_guests = []


# Called when the node enters the scene tree for the first time.
func _ready():
	#Load guests info, instantiate the scenes and save them in an array
	if SaveSystem.load_guest():
		grid_blocks = grid.get_children()
		
		guests = SaveSystem.load_guest()
		for g in guests:
			var _guest_portrait = guest_portrait.instantiate()
			_guest_portrait.guest_name = guests[g]["Name"]
			_guest_portrait.country = guests[g]["Country"]
			_guest_portrait.birth = guests[g]["Birth"]
			_guest_portrait.death = guests[g]["Death"]
			_guest_portrait.famous_for = guests[g]["Famous for"]
			_guest_portrait.image_1 = guests[g]["Image 1"]
			loaded_guests.append(_guest_portrait)
			
	else: print("Couldn't load guests.")
	#Add color blocks to array

func show_guests():
	var new_occupied_block = grid_blocks.pick_random()
	if occupied_blocks.has(new_occupied_block):
		new_occupied_block = grid_blocks.pick_random()
	else:
		occupied_blocks.append(new_occupied_block)
	var new_shown_guest = loaded_guests.pick_random()
	if shown_guests.has(new_shown_guest):
		new_shown_guest = loaded_guests.pick_random()
	else:
		shown_guests.append(new_shown_guest)
	new_occupied_block.add_child(new_shown_guest)

func hide_guests():
	var random_block_to_remove = occupied_blocks.pick_random()
	for o in random_block_to_remove.get_children():
		if shown_guests.has(o):
			random_block_to_remove.remove_child(o)
			for sg in shown_guests:
				if sg == o:
					shown_guests.remove_at(shown_guests[sg])
			for ob in occupied_blocks:
				if ob == random_block_to_remove:
					occupied_blocks.remove_at(occupied_blocks[ob])


func _on_timer_timeout():
	if occupied_blocks.size() == max_occupied_blocks:
		if rng.randf_range(0,1) > chance:
			hide_guests()
			print("Hiding guest!")
		else:
			show_guests()
	else:
		show_guests()
		
func show_guest(guest : Guest):
	
