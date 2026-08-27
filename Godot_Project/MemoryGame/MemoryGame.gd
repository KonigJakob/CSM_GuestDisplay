extends Control

signal buttons_added()

var game_button = preload("res://MemoryGame/MemoryButton.tscn")

var grid_parent : GridContainer
var game_buttons : Array
var game_sequence : Array 
var current_step : int = 0

@export var number_of_squares : int = 1

func _ready():
	grid_parent = $BlocksContainer
	add_buttons()
	connect_button_signals()
	start_game()
	turn_button_on()

func add_buttons() -> void:
	for i in range(number_of_squares):
		var game_button_instance = game_button.instantiate()
		game_button_instance.set_meta("id",i+1)
		game_button_instance.get_child(0).color = Color.MEDIUM_PURPLE
		game_buttons.append(game_button_instance)
		grid_parent.add_child(game_button_instance)
	buttons_added.emit()

func connect_button_signals():
	for i in range(game_buttons.size()):
		game_buttons[i].button_up.connect(func(): on_game_button_up(game_buttons[i].get_meta("id")))
		pass

func start_game():
	game_sequence = set_game_sequence()
	current_step = 0
	flash_buttons(Color.BLUE)

func set_game_sequence() -> Array:
	var sequence: Array = []
	if number_of_squares == 1: 
		sequence.append(1)
		return sequence
	else:
		for i in range(number_of_squares):
			var rng = randi_range(1, number_of_squares)
			while rng in sequence:
				rng = randi_range(1, number_of_squares)
			sequence.append(rng)
	return sequence

func turn_button_on():
	flash_button(grid_parent.color_rects[game_sequence[0]-1], Color.YELLOW)

func on_game_button_up(id : int):
	check_sequence(id)

func check_sequence(id : int):
	print("ID: " + str(id))
	if id == game_sequence[current_step]:
		current_step += 1
		recolor_game_buttons(id - 1)
		if current_step == game_sequence.size():
			current_step = 0
			print("sequence completed")
			game_sequence = set_game_sequence()
			reset_buttons()
			turn_button_on()
	else:
		current_step = 0
		flash_buttons(Color.RED)
		
		print("wrong!")
		
func recolor_game_buttons(id : int):
	game_buttons[id].get_child(0).color = Color.BLUE
	if current_step < game_buttons.size():
		var next_id = game_sequence[current_step]
		flash_button(game_buttons[next_id - 1].get_child(0), Color.YELLOW)

func reset_buttons():
	for b in game_buttons:
		b.get_child(0).color = Color.MEDIUM_PURPLE

func flash_buttons(color : Color):
	var flash_tween = get_tree().create_tween().set_loops(1).set_parallel()
	
	for b in game_buttons:
		flash_tween.tween_property(b.get_child(0), "color", color, 0.2)
	
	flash_tween.chain()
	
	for b in game_buttons:
		flash_tween.tween_property(b.get_child(0), "color", Color.MEDIUM_PURPLE, 0.2)
		
	flash_tween.chain()
	
	for b in game_buttons:
		flash_tween.tween_property(b.get_child(0), "color", color, 0.2)
	
	flash_tween.chain()
	
	for b in game_buttons:
		flash_tween.tween_property(b.get_child(0), "color", Color.MEDIUM_PURPLE, 0.2)
	
	flash_tween.chain()

	flash_tween.tween_callback(turn_button_on)

func flash_button(b : ColorRect, color : Color):
	var single_flash_tween = get_tree().create_tween().set_loops(2).set_parallel()
	single_flash_tween.tween_property(b, "color", color, 0.2)
	single_flash_tween.chain()
	single_flash_tween.tween_property(b, "color", Color.MEDIUM_PURPLE, 0.2)

