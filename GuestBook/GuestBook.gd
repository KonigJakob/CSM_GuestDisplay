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
@export var submit_button: Button

@export var Star_One: Button
@export var Star_Two: Button
@export var Star_Three: Button
@export var Star_Four: Button
@export var Star_Five: Button

@export var Age_Child: Button
@export var Age_Teen: Button
@export var Age_Adult: Button
@export var Age_Senior: Button

# Called when the node enters the scene tree for the first time.
func _ready():
	satisfaction_button = 0
	age_group_button = 0
	date = Time.get_date_string_from_system()
	remove_child(promt_panel)

func _on_star_1_pressed():
	satisfaction_button = 1
	Star_Two.button_pressed = false
	Star_Three.button_pressed = false
	Star_Four.button_pressed = false
	Star_Five.button_pressed = false
func _on_star_2_pressed():
	satisfaction_button = 2
	Star_One.button_pressed = true
	Star_Three.button_pressed = false
	Star_Four.button_pressed = false
	Star_Five.button_pressed = false
func _on_star_3_pressed():
	satisfaction_button = 3
	Star_One.button_pressed = true
	Star_Two.button_pressed = true
	Star_Four.button_pressed = false
	Star_Five.button_pressed = false
func _on_star_4_pressed():
	satisfaction_button = 4
	Star_One.button_pressed = true
	Star_Two.button_pressed = true
	Star_Three.button_pressed = true
	Star_Five.button_pressed = false
func _on_star_5_pressed():
	satisfaction_button = 5
	Star_One.button_pressed = true
	Star_Two.button_pressed = true
	Star_Three.button_pressed = true
	Star_Four.button_pressed = true

func _on_button_baby_pressed():
	age_group_button = 1
	Age_Teen.button_pressed = false
	Age_Adult.button_pressed = false
	Age_Senior.button_pressed = false
func _on_button_young_pressed():
	age_group_button = 2
	Age_Child.button_pressed = false
	Age_Adult.button_pressed = false
	Age_Senior.button_pressed = false
func _on_button_adult_pressed():
	age_group_button = 3
	Age_Child.button_pressed = false
	Age_Teen.button_pressed = false
	Age_Senior.button_pressed = false
func _on_button_senior_pressed():
	age_group_button = 4
	Age_Child.button_pressed = false
	Age_Teen.button_pressed = false
	Age_Adult.button_pressed = false

func _on_option_button_item_selected(index):
	language = index

func _on_line_edit_text_changed(new_text):
	message = new_text

func _on_button_no_pressed():
	get_tree().change_scene_to_file("res://MainMenu/main.tscn")

func _on_button_yes_pressed():
	get_tree().reload_current_scene()

func _on_button_return_pressed():
	var panels = $Control
	var panel_size = panels.size/panels.get_child_count()
	var tween = get_tree().create_tween()
	tween.tween_property(panels, "position", Vector2(panels.position.x + panel_size.x, panels.position.y),1)
	current_page -= 1
	match current_page: 
		PollPage.STARS:
			back_button.visible = false
			forward_button.visible = true
			submit_button.visible = false
		PollPage.AGE:
			back_button.visible = true
			forward_button.visible = true
			submit_button.visible = false
		PollPage.LANGUAGE:
			back_button.visible = true
			forward_button.visible = true
			submit_button.visible = false
		PollPage.MESSAGE:
			back_button.visible = true
			forward_button.visible = false
			submit_button.visible = true
func _on_button_continue_pressed():
	var panels = $Control
	var panel_size = panels.size/panels.get_child_count()
	var tween = get_tree().create_tween()
	tween.tween_property(panels, "position", Vector2(panels.position.x - panel_size.x, panels.position.y),1)
	current_page += 1
	match current_page: 
		PollPage.STARS:
			back_button.visible = false
			forward_button.visible = true
			submit_button.visible = false
		PollPage.AGE:
			back_button.visible = true
			forward_button.visible = true
			submit_button.visible = false
		PollPage.LANGUAGE:
			back_button.visible = true
			forward_button.visible = true
			submit_button.visible = false
		PollPage.MESSAGE:
			back_button.visible = true
			forward_button.visible = false
			submit_button.visible = true

func _on_button_home_pressed():
	get_tree().change_scene_to_file("res://MainMenu/main.tscn")

func _on_button_submit_pressed():
	poll_data = {"Date" : date, "Satisfaction": satisfaction_button, 
	"Age Group" : age_group_button, "Language" : language, "Message" : message}
	JSON_string = JSON.stringify(poll_data)
	SaveSystem.save(JSON_string)
	add_child(promt_panel)
	promt_panel.global_position = Vector2.ZERO
