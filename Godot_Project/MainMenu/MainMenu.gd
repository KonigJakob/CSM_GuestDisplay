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
	animate_background()

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

func animate_block_colors():
	if tween:
		tween.kill()
	tween = get_tree().create_tween().set_loops(-1)
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.set_trans(Tween.TRANS_SINE)
	for b in blocks.size():
		tween.tween_property(blocks[b], "color", blocks[blocks.size()-1-b].color, tween_duration)
	colors_changed = true

func animate_background():
	# Continuous rotation tween (loops forever on its own)
	var rot_tween = get_tree().create_tween().set_loops()
	rot_tween.tween_property($TextureRect2, "rotation_degrees", 360.0, 60.0)\
	.as_relative()  

	# Scale pulse tween (grow then shrink, loops forever)
	var scale_tween = get_tree().create_tween().set_loops()
	scale_tween.tween_property($TextureRect2, "scale", Vector2(1.3, 1.3), 30)\
	.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	scale_tween.tween_property($TextureRect2, "scale", Vector2(0.6, 0.6), 30).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

func reset_block_colors():
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	for b in blocks.size():
		if b+1 <= blocks.size():
			tween.tween_property(blocks[b], "color", block_colors[b], tween_duration)
		else:
			tween.tween_property(blocks[b-1], "color", block_colors[0], tween_duration)
	colors_changed = false

func _on_color_timer_timeout():
	if colors_changed:
		reset_block_colors()
	else:
		animate_block_colors()
