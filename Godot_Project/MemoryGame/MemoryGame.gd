extends Control

signal buttons_added()
signal game_started()
signal successful_sequence()

var game_button = preload("res://MemoryGame/MemoryButton.tscn")

var grid_parent : GridContainer
var game_buttons : Array
var game_sequence : Array 
var current_step : int = 0

var home_button : button_syled

@export var number_of_squares : int = 1

func _ready():
	grid_parent = $BlocksContainer
	home_button = $Button_Home
	var viewport = get_viewport_rect().size
	home_button.position = Vector2(viewport.x/2 - home_button.size.x/2, viewport.y - home_button.size.y * 2)
	add_buttons()
	connect_button_signals()
	start_game()
	turn_button_on()

func add_buttons() -> void:
	for i in range(number_of_squares):
		var game_button_instance = game_button.instantiate()
		game_button_instance.set_meta("id",i+1)
		game_buttons.append(game_button_instance)
		grid_parent.add_child(game_button_instance)
	buttons_added.emit()

func connect_button_signals():
	for i in range(game_buttons.size()):
		game_buttons[i].button_up.connect(func(): on_game_button_up(game_buttons[i].get_meta("id")))
		
func disconnect_button_signals():
	for i in range(game_buttons.size()):
		game_buttons[i].button_up.diconnect(func(): on_game_button_up(game_buttons[i].get_meta("id")))

func start_game():
	game_sequence = set_game_sequence()
	current_step = 0
	#flash_buttons(Color.BLUE)

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
	game_started.emit()
	check_sequence(id)

func check_sequence(id : int):
	print("ID: " + str(id))
	if id == game_sequence[current_step]:
		current_step += 1
		#recolor_game_buttons(id - 1)
		disable_button(id - 1)
		if current_step == game_sequence.size():
			current_step = 0
			print("sequence completed")
			game_sequence = set_game_sequence()
			successful_sequence.emit()
	else:
		current_step = 0
		flash_buttons(Color.RED)
		reset_buttons()
		
		print("wrong!")
		
func recolor_game_buttons(id : int):
	game_buttons[id].get_child(0).color = Color.BLUE

func reset_buttons():
	for b in game_buttons:
		if b.disabled == true:
			b.disabled = false
			grid_parent.animate_square_in(b.get_child(0))
			
func restart_game():
	grid_parent.color_of_squares = SaveSystem.block_colors.pick_random()
	flash_buttons(Color.DARK_VIOLET)
	start_game()
	reset_buttons()
	turn_button_on()

func flash_buttons(color : Color):
	var flash_tween = get_tree().create_tween().set_loops(1).set_parallel()
	
	for b in game_buttons:
		flash_tween.tween_property(b.get_child(0), "color", color, 0.2)
	
	flash_tween.chain()
	
	for b in game_buttons:
		flash_tween.tween_property(b.get_child(0), "color", b.get_parent().color_of_squares, 0.2)
		
	flash_tween.chain()
	
	for b in game_buttons:
		flash_tween.tween_property(b.get_child(0), "color", color, 0.2)
	
	flash_tween.chain()
	
	for b in game_buttons:
		flash_tween.tween_property(b.get_child(0), "color", b.get_parent().color_of_squares, 0.2)
	

func flash_button(b : ColorRect, color : Color):
	var single_flash_tween = get_tree().create_tween().set_loops(4).set_parallel()
	single_flash_tween.tween_property(b, "color", color, 0.2)
	single_flash_tween.chain()
	single_flash_tween.tween_property(b, "color", grid_parent.color_of_squares, 0.2)

func disable_button(id : int):
	var button_to_remove = game_buttons[id]
	button_to_remove.disabled = true
	grid_parent.animate_square_out(button_to_remove.get_child(0))

func _on_button_styled_child_button_pressed():
	restart_game()

func _on_translation_de_child_button_pressed():
	TranslationServer.set_locale("de")
func _on_translation_en_child_button_pressed():
	TranslationServer.set_locale("en")


func _on_button_home_child_button_pressed():
	SceneManager.target_scene = "res://MainMenu/main.tscn"
	get_tree().change_scene_to_file("res://UI_Details/LoadingScene.tscn")
