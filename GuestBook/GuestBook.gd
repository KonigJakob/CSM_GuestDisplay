extends Control

var satisfaction_button : int
var age_group_button: int
var date : String
var language : int
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

@export var forward_button: Button
@export var back_button: Button
@export var tween_wait_interval: float
@export var tween_movement_interval: float
@export var submit_button: Button

@export var panels : HBoxContainer

@export var Star_One: Button
@export var Star_Two: Button
@export var Star_Three: Button
@export var Star_Four: Button
@export var Star_Five: Button

@export var Age_Child: button_syled
@export var Age_Teen: button_syled
@export var Age_Adult: button_syled
@export var Age_Senior: button_syled
var age_buttons = []

# Called when the node enters the scene tree for the first time.
func _ready():
	satisfaction_button = 0
	age_group_button = 0
	age_buttons = get_tree().get_nodes_in_group("age_buttons")
	date = Time.get_date_string_from_system()
	remove_child(promt_panel)

func _on_star_1_pressed():
	satisfaction_button = 1
	Star_Two.button_pressed = false
	Star_Three.button_pressed = false
	Star_Four.button_pressed = false
	Star_Five.button_pressed = false
	tween_forward()
func _on_star_2_pressed():
	satisfaction_button = 2
	Star_One.button_pressed = true
	Star_Three.button_pressed = false
	Star_Four.button_pressed = false
	Star_Five.button_pressed = false
	tween_forward()
func _on_star_3_pressed():
	satisfaction_button = 3
	Star_One.button_pressed = true
	Star_Two.button_pressed = true
	Star_Four.button_pressed = false
	Star_Five.button_pressed = false
	tween_forward()
func _on_star_4_pressed():
	satisfaction_button = 4
	Star_One.button_pressed = true
	Star_Two.button_pressed = true
	Star_Three.button_pressed = true
	Star_Five.button_pressed = false
	tween_forward()
func _on_star_5_pressed():
	satisfaction_button = 5
	Star_One.button_pressed = true
	Star_Two.button_pressed = true
	Star_Three.button_pressed = true
	Star_Four.button_pressed = true
	tween_forward()

func _on_button_child_pressed():
	age_group_button = 1
	unpress_buttons(Age_Child)
	tween_forward()
func _on_button_teen_pressed():
	age_group_button = 2
	unpress_buttons(Age_Teen)
	tween_forward()
func _on_button_adult_pressed():
	age_group_button = 3
	unpress_buttons(Age_Adult)
	tween_forward()
func _on_button_senior_pressed():
	age_group_button = 4
	unpress_buttons(Age_Senior)
	tween_forward()

func unpress_buttons(button_parent):
	print(button_parent)
	for b in age_buttons:
		if b == button_parent:
			continue
		else:
			if b is button_syled:
				b.toggle_pressed()
				print("toggled: ", b.name)

func _on_option_button_item_selected(index):
	language = index
	tween_forward()

func _on_text_changed(new_text):
	message = new_text
	var tween = get_tree().create_tween()
	tween.tween_property(submit_button, "visible", true, tween_wait_interval * 2)

func _on_button_no_pressed():
	get_tree().change_scene_to_file("res://MainMenu/main.tscn")

func _on_button_yes_pressed():
	get_tree().reload_current_scene()

func _on_button_return_pressed():
	move_page_backwards()

func _on_button_continue_pressed():
	move_page_forward()

func _on_button_home_pressed():
	get_tree().change_scene_to_file("res://MainMenu/main.tscn")

func _on_button_submit_pressed():
	poll_data = {"Date" : date, "Satisfaction": satisfaction_button, 
	"Age Group" : age_group_button, "Language" : language, "Message" : message}
	JSON_string = JSON.stringify(poll_data)
	SaveSystem.save(JSON_string)
	add_child(promt_panel)
	promt_panel.global_position = Vector2.ZERO

func move_page_forward():
	var panel_size = panels.size/panels.get_child_count()
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	tween.tween_property(panels, "position", Vector2(panels.position.x - panel_size.x, panels.position.y),tween_movement_interval)
	current_page += 1
	update_page_buttons()
func move_page_backwards():
	var panel_size = panels.size/panels.get_child_count()
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	tween.tween_property(panels, "position", Vector2(panels.position.x + panel_size.x, panels.position.y),tween_movement_interval)
	current_page -= 1
	update_page_buttons()
func tween_forward():
	var tween = get_tree().create_tween()
	tween.tween_interval(tween_wait_interval)
	tween.tween_callback(move_page_forward)
func update_page_buttons():
	match current_page: 
		PollPage.STARS:
			back_button.visible = false
			submit_button.visible = false
		PollPage.AGE:
			back_button.visible = true
			submit_button.visible = false
		PollPage.LANGUAGE:
			back_button.visible = true
			submit_button.visible = false
		PollPage.MESSAGE:
			back_button.visible = true
