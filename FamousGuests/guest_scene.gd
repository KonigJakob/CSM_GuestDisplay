extends Control

class_name Guest

var guest_name : String
var country : String
var birth : String
var death : String
var famous_for : String
var image_1 : String
var image_2 : String

var shown : bool = false
var portrait_panel

@export var info_panel : Control
@export var button : Button
@export var container : VBoxContainer

@export var default_values : bool = false



func _ready():
	portrait_panel = get_parent()
	button.size = portrait_panel.size
	container.size = portrait_panel.size
	print(get_parent())
	if default_values:
		$VBoxContainer/TextureRect.texture = load("res://Assets/Textures/images.jpeg")
		$VBoxContainer/Label.text = "Miyamoto"
	else:
		pass


func _on_button_pressed():
	if info_panel.visible == false:
		info_panel.visible = true
