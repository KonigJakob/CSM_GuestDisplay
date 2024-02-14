extends Control

var rng = RandomNumberGenerator.new()
var chance : float = 0.5

var portraits : Array
var guests = {}
var loaded_guests = []
var guest_portrait = preload("res://FamousGuests/guest_scene.tscn")

@onready var grid = $GridContainer
var grid_blocks = []
var occupied_blocks : int
var shown_guests : int
var max_occupied_blocks : int = 5


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
	if new_occupied_block is Grid_ColorRect:
		if !new_occupied_block.occupied:
			new_occupied_block.occupied = true
			var new_shown_guest = loaded_guests.pick_random()
			if new_shown_guest is Guest:
				if !new_shown_guest.shown:
					new_shown_guest.shown = true
					new_occupied_block.add_child(new_shown_guest)
					new_shown_guest.position = new_shown_guest.get_parent().position
					print("Do you see a guest?")
		else:
			new_occupied_block = grid_blocks.pick_random()

func hide_guest():
	pass


func _on_timer_timeout():
	show_guests()
	
func _on_guest_timer_timeout():
	hide_guest()
