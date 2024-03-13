extends Control

var satisfaction_button : int
var age_group_button: String
var date : String
var language : String
var message : String

var poll_data : Dictionary
var JSON_string

@onready var promt_panel : Control = $Promt_Panel

enum PollPage {
	STARS,
	AGE,
	LANGUAGE,
	MESSAGE,
}
@onready var current_page = PollPage.STARS

@export var back_button: button_syled
@export var tween_wait_interval: float
@export var tween_movement_interval: float
@export var submit_button: button_syled
@export var logo_rect : TextureRect
@export var button_home : button_syled
@export var localization_buttons : HBoxContainer

@export var panels : HBoxContainer

@export var Star_One: Button
@export var Star_Two: Button
@export var Star_Three: Button
@export var Star_Four: Button
@export var Star_Five: Button

@export var Age_Child: button_syled
@export var Age_Teen: button_syled
@export var Age_YoungAdult : button_syled
@export var Age_Adult: button_syled
@export var Age_MidAged : button_syled
@export var Age_Senior: button_syled

@export var option_button: OptionButton

@export var lock_rect: ColorRect
var stars = []
var age_buttons = []
var text_changed : bool  = false
var keep_visible : bool = false

func _ready():
	set_up_ui_elements()
	satisfaction_button = 0
	age_buttons = get_tree().get_nodes_in_group("age_buttons")
	date = Time.get_date_string_from_system()
	remove_child(promt_panel)
	stars = get_tree().get_nodes_in_group("star_buttons")
	update_page_buttons()
	submit_button.modulate.a = 0

func set_up_ui_elements():
	logo_rect.position = Vector2(get_viewport_rect().size.x/2 - logo_rect.size.x/2, 100)
	button_home.position = Vector2(get_viewport_rect().size.x/2 - button_home.size.x/2, get_viewport_rect().size.y - button_home.size.y * 2)
	back_button.position = Vector2(panels.position.x, button_home.position.y)
	submit_button.position = Vector2(get_viewport_rect().size.x - submit_button.size.x - 200, panels.position.y)
	localization_buttons.position = Vector2(get_viewport_rect().size.x - localization_buttons.size.x - 35, button_home.position.y + button_home.size.y/4)

func _on_star_1_pressed():
	satisfaction_button = 1
	press_stars(satisfaction_button)
	tween_forward()
func _on_star_2_pressed():
	satisfaction_button = 2
	press_stars(satisfaction_button)
	tween_forward()
func _on_star_3_pressed():
	satisfaction_button = 3
	press_stars(satisfaction_button)
	tween_forward()
func _on_star_4_pressed():
	satisfaction_button = 4
	press_stars(satisfaction_button)
	tween_forward()
func _on_star_5_pressed():
	satisfaction_button = 5
	Star_One.button_pressed = true
	Star_Two.button_pressed = true
	Star_Three.button_pressed = true
	Star_Four.button_pressed = true
	tween_forward()

func press_stars(star_index : int):
	for i in stars.size():
		if i+1 <= star_index:
			stars[i].button_pressed = true
		else: 
			stars[i].button_pressed = false

func _on_button_child_pressed():
	age_group_button = "0-12"
	unpress_buttons(Age_Child)
	tween_forward()
	keep_button_pressed(Age_Child)
func _on_button_teen_pressed():
	age_group_button = "13-18"
	unpress_buttons(Age_Teen)
	tween_forward()
	keep_button_pressed(Age_Teen)
func _on_button_adult_pressed():
	age_group_button = "31-45"
	unpress_buttons(Age_Adult)
	tween_forward()
	keep_button_pressed(Age_Adult)
func _on_button_young_adult_pressed():
	age_group_button = "19-30"
	unpress_buttons(Age_YoungAdult)
	tween_forward()
	keep_button_pressed(Age_YoungAdult)
func _on_button_mid_aged_pressed():
	age_group_button = "46-60"
	unpress_buttons(Age_MidAged)
	tween_forward()
	keep_button_pressed(Age_MidAged)
func _on_button_senior_pressed():
	age_group_button = "60+"
	unpress_buttons(Age_Senior)
	tween_forward()
	keep_button_pressed(Age_Senior)

func unpress_buttons(button_parent):
	for b in age_buttons:
		if b == button_parent:
			continue
		else:
			if b is button_syled:
				b.toggle_pressed()
func keep_button_pressed(button_parent : button_syled):
	if button_parent.button_pressed:
		button_parent.keep_pressed()

func _on_option_button_item_selected(index):
	language = option_button.get_item_text(index)
	tween_forward()

func _on_text_changed(new_text):
	message = new_text
	if !text_changed:
		text_changed = true
		tween_visibility(submit_button)

func _on_button_no_pressed():
	SceneManager.target_scene = "res://MainMenu/main.tscn"
	get_tree().change_scene_to_file("res://UI_Details/LoadingScene.tscn")
func _on_button_yes_pressed():
	get_tree().reload_current_scene()
func _on_button_return_pressed():
	move_page_backwards()
func _on_button_continue_pressed():
	move_page_forward()
func _on_button_home_pressed():
	SceneManager.target_scene = "res://MainMenu/main.tscn"
	get_tree().change_scene_to_file("res://UI_Details/LoadingScene.tscn")
	
func _on_button_submit_pressed():
	submit_guest_info()
	add_child(promt_panel)
	tween_visibility(promt_panel)
	promt_panel.global_position = Vector2.ZERO

func submit_guest_info():
	var new_answer
	var guest_id = "Guest_" + Time.get_time_string_from_system()
	poll_data = {"Date" : date, "Satisfaction": satisfaction_button, 
	"Age Group" : age_group_button, "Language" : language, "Message" : message}
	new_answer = {guest_id: poll_data}
	JSON_string = JSON.stringify(new_answer, "\t", false)
	SaveSystem.save(JSON_string)

func move_page_forward():
	var panel_size = panels.size/panels.get_child_count()
	var tween = get_tree().create_tween()
	lock_rect.visible = true
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	tween.tween_property(panels, "position", Vector2(panels.position.x - panel_size.x - 75, panels.position.y),tween_movement_interval)
	current_page += 1
	update_page_buttons()
	tween.finished.connect(on_tween_finished)
func move_page_backwards():
	var panel_size = panels.size/panels.get_child_count()
	var tween = get_tree().create_tween()
	lock_rect.visible = true
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	tween.tween_property(panels, "position", Vector2(panels.position.x + panel_size.x + 75, panels.position.y),tween_movement_interval)
	current_page -= 1
	update_page_buttons()
	tween.finished.connect(on_tween_finished)
func tween_forward():
	var tween = get_tree().create_tween()
	tween.tween_interval(tween_wait_interval)
	tween.tween_callback(move_page_forward)
func on_tween_finished():
	lock_rect.visible = false

func update_page_buttons():
	match current_page: 
		PollPage.STARS:
			tween_visibility(back_button)
			keep_visible = false
		PollPage.AGE:
			back_button.visible = true
			if !keep_visible:
				tween_visibility(back_button)
				keep_visible = true
		PollPage.LANGUAGE:
			back_button.visible = true
		PollPage.MESSAGE:
			back_button.visible = true
func tween_visibility(object_to_modulate) -> void:
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	if object_to_modulate.modulate.a == 0:
		tween.tween_property(object_to_modulate, "modulate:a", 1, tween_movement_interval)
	else:
		tween.tween_property(object_to_modulate, "modulate:a", 0, tween_movement_interval)
		tween.tween_property(object_to_modulate, "visible", false, tween_wait_interval/2)

func _on_translation_de_child_button_pressed():
	SceneManager.set_language("de")
func _on_translation_en_child_button_pressed():
	SceneManager.set_language("en")
