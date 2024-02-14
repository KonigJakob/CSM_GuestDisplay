extends Control

var satisfaction_button : int
var age_group_button: int
var date : String
var language : int
var message : String

var poll_data : Dictionary
var JSON_string

@onready var promt_panel : Control = $Promt_Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	satisfaction_button = 0
	age_group_button = 0
	date = Time.get_date_string_from_system()
	remove_child(promt_panel)
	
func _process(delta):
	if Input.is_action_pressed("load"):
		#SaveSystem.load()
		pass

func _on_button_v_bad_pressed():
	satisfaction_button = 1
	$Satisfaction/Button_Bad.button_pressed = false
	$Satisfaction/Button_Meh.button_pressed = false
	$Satisfaction/Button_Good.button_pressed = false
	$Satisfaction/Button_VGood.button_pressed = false
func _on_button_bad_pressed():
	satisfaction_button = 2
	$Satisfaction/Button_VBad.button_pressed = false
	$Satisfaction/Button_Meh.button_pressed = false
	$Satisfaction/Button_Good.button_pressed = false
	$Satisfaction/Button_VGood.button_pressed = false
func _on_button_meh_pressed():
	satisfaction_button = 3
	$Satisfaction/Button_VBad.button_pressed = false
	$Satisfaction/Button_Bad.button_pressed = false
	$Satisfaction/Button_Good.button_pressed = false
	$Satisfaction/Button_VGood.button_pressed = false
func _on_button_good_pressed():
	satisfaction_button = 4
	$Satisfaction/Button_VBad.button_pressed = false
	$Satisfaction/Button_Bad.button_pressed = false
	$Satisfaction/Button_Meh.button_pressed = false
	$Satisfaction/Button_VGood.button_pressed = false
func _on_button_v_good_pressed():
	satisfaction_button = 5
	$Satisfaction/Button_VBad.button_pressed = false
	$Satisfaction/Button_Bad.button_pressed = false
	$Satisfaction/Button_Meh.button_pressed = false
	$Satisfaction/Button_Good.button_pressed = false


func _on_button_baby_pressed():
	age_group_button = 1
	$Age_Group/Button_Young.button_pressed = false
	$Age_Group/Button_Adult.button_pressed = false

func _on_button_young_pressed():
	age_group_button = 2
	$Age_Group/Button_Baby.button_pressed = false
	$Age_Group/Button_Adult.button_pressed = false


func _on_button_adult_pressed():
	age_group_button = 3
	$Age_Group/Button_Baby.button_pressed = false
	$Age_Group/Button_Young.button_pressed = false


func _on_option_button_item_selected(index):
	language = index


func _on_line_edit_text_changed(new_text):
	message = new_text


func _on_button_pressed():
	poll_data = {"Date" : date, "Satisfaction": satisfaction_button, 
	"Age Group" : age_group_button, "Language" : language, "Message" : message}
	JSON_string = JSON.stringify(poll_data)
	SaveSystem.save(JSON_string)
	add_child(promt_panel)
	
func _on_button_no_pressed():
	get_tree().change_scene_to_file("res://MainMenu/main.tscn")

func _on_button_yes_pressed():
	get_tree().reload_current_scene()


func _on_button_return_pressed():
	get_tree().change_scene_to_file("res://MainMenu/main.tscn")
