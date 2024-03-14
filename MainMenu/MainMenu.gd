extends Control

@export var localization_buttons : HBoxContainer
@export var logo : TextureRect
@export var welcome : Label
@export var tween_duration : float
@onready var color_timer = $ColorTimer
@onready var grid = $GridContainer
var blocks = []
var block_colors = []
var colors_changed : bool

var tween

func _ready():
	localization_buttons.position.x = grid.size.x - localization_buttons.size.x
	localization_buttons.position.y = get_viewport_rect().size.y - localization_buttons.size.y - 35
	logo.position = Vector2(get_viewport_rect().size.x/2 - logo.size.x/2, 100)
	welcome.position = Vector2(get_viewport_rect().size.x/2 - welcome.size.x/2, logo.position.y + logo.size.y + 105)
	blocks = get_tree().get_nodes_in_group("blocks")
	block_colors = get_block_colors()
	animate_block_colors()

func _input(event):
	if event is InputEventMouseButton:
		animate_block_colors()
	if event is InputEventKey:
		reset_block_colors()

func _on_button_famous_guests_pressed():
	if tween:
		tween.kill()
	SceneManager.target_scene = "res://FamousGuests/FamousGuests.tscn"
	get_tree().change_scene_to_file("res://UI_Details/LoadingScene.tscn")

func _on_button_guest_book_pressed():
	if tween:
		tween.kill()
	SceneManager.target_scene = "res://GuestBook/GuestBook.tscn"
	get_tree().change_scene_to_file("res://UI_Details/LoadingScene.tscn")

func _on_translation_de_child_button_pressed():
	TranslationServer.set_locale("de")
func _on_translation_en_child_button_pressed():
	TranslationServer.set_locale("en")
	
func get_block_colors() -> Array:
	for b in blocks:
		block_colors.append(b.color)
	return block_colors
	
func get_alt_block_colors() -> Array:
	var block_alt_colors = []
	for b in blocks.size():
		blocks[b].color = blocks[blocks.size()-1-b]
		
	return block_alt_colors
	
func animate_block_colors():
	tween = get_tree().create_tween().set_loops(-1)
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.set_trans(Tween.TRANS_SINE)
	print(blocks.size())
	for b in blocks.size():
		tween.tween_property(blocks[b], "color", blocks[blocks.size()-1-b].color, tween_duration * 2)
	colors_changed = true

func reset_block_colors():
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	for b in blocks.size():
		if b+1 <= blocks.size():
			tween.tween_property(blocks[b], "color", block_colors[b], tween_duration * 2)
		else:
			tween.tween_property(blocks[b-1], "color", block_colors[0], tween_duration * 2)
	colors_changed = false

func _on_color_timer_timeout():
	if colors_changed:
		reset_block_colors()
	else:
		animate_block_colors()
