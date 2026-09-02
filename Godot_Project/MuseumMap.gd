extends Control

var rot_tween
var scale_tween
var tile_enter_tween

var maptiles_parent : Control
var maptiles : Array[Node]
var letters_parent : Control

var viewport

@export var animate_tiles_tween_duration : float = 0.2
@export var animate_tiles_height : int = 200

@export var home_button: button_syled
@export var localization_buttons : HBoxContainer
@export var logo : TextureRect

func _ready():
	letters_parent = $Letters
	animate_background()
	maptiles_parent = $MapTiles
	maptiles = maptiles_parent.get_children()
	set_up_tiles()
	animate_tiles()
	
	viewport = get_viewport_rect().size
	
	home_button.position = Vector2(viewport.x/2 - home_button.size.x/2, viewport.y - home_button.size.y * 2)
	localization_buttons.position.x = logo.position.x + (logo.size.x * logo.scale.x) - localization_buttons.size.x
	localization_buttons.position.y = get_viewport_rect().size.y - localization_buttons.size.y - 50

func animate_background():
	# Continuous rotation tween (loops forever on its own)
	if rot_tween:
		rot_tween.kill()
	rot_tween = get_tree().create_tween().set_loops(0)
	rot_tween.tween_property($BackgroundLogo, "rotation_degrees", 360.0, 60.0)\
	.as_relative()  
	rot_tween.bind_node(self)

	# Scale pulse tween (grow then shrink, loops forever)
	if scale_tween:
		scale_tween.kill()
	scale_tween = get_tree().create_tween().set_loops(0)
	scale_tween.tween_property($BackgroundLogo, "scale", Vector2(1.3, 1.3), 30)\
	.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	scale_tween.tween_property($BackgroundLogo, "scale", Vector2(0.6, 0.6), 30).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	scale_tween.bind_node(self)

func set_up_tiles():
	for t in maptiles:
		t.position = t.position - Vector2(0,animate_tiles_height)
		t.visible = false

func animate_tiles():
	if tile_enter_tween:
		tile_enter_tween.kill()
	maptiles.reverse()
	tile_enter_tween = get_tree().create_tween().set_loops(1).set_parallel()
	var i = 0
	for t in maptiles:
		tile_enter_tween.tween_property(t, "visible", true, 0).set_delay(i * animate_tiles_tween_duration/2)
		tile_enter_tween.tween_property(t, "position", t.position + Vector2(0,animate_tiles_height), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_delay(i * animate_tiles_tween_duration/2)
		i += 1
	tile_enter_tween.tween_property(letters_parent, "visible", true, 0).set_delay((maptiles.size()+1) * (animate_tiles_tween_duration/2))
	tile_enter_tween.tween_property(letters_parent, "position", letters_parent.position + Vector2(0, 50), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_delay((maptiles.size()+1) * (animate_tiles_tween_duration/2))

func random_tile_bounce():
	var tile_to_animate = maptiles.pick_random()
	if tile_to_animate.is_pressed:
		pass
	var bounce_tween = get_tree().create_tween().set_loops(1)
	bounce_tween.tween_property(tile_to_animate, "position", Vector2(0, -30),0.5).as_relative().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	bounce_tween.tween_property(tile_to_animate, "position", Vector2(0, 30),0.3).as_relative().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	$RandomBounceTimer.start(randi_range(3,6))
	
func _on_translation_de_child_button_pressed():
	TranslationServer.set_locale("de")
func _on_translation_en_child_button_pressed():
	TranslationServer.set_locale("en")
func _on_button_home_pressed():
	SceneManager.target_scene = "res://MainMenu/main.tscn"
	get_tree().change_scene_to_file("res://UI_Details/LoadingScene.tscn")
	
