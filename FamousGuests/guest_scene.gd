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

@export var default_values : bool = false



func _ready():
	if default_values:
		$VBoxContainer/TextureRect.texture = load("res://Assets/Textures/images.jpeg")
		$VBoxContainer/Label.text = "Miyamoto"
	else:
		pass


func _on_button_pressed():
	if $Button/Button.visible == false:
		$Button/Button.visible = true
	else:
		$Button/Button.visible = false
