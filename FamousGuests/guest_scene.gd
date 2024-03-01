extends Control

class_name Guest

var guest_id : String
var guest_name : String
var country : String
var birth : String
var famous_for : String
var image_1 : String
var image_2 : String
var image_3 : String
var portrait : String

var shown : bool = false
var portrait_panel

@export var info_panel : Control
@export var button : Button
@export var container : VBoxContainer

func _ready():
	portrait_panel = get_parent()
	button.size = portrait_panel.size
	container.size = portrait_panel.size

func _on_button_pressed():
	if info_panel.visible == false:
		info_panel.visible = true

func update_guest_info() -> void:
	$Button/VBoxContainer/PortraitName.text = guest_name
	$Button/InfoPanel/VBoxContainer/MarginContainer2/VBoxContainer/Name.text = guest_name
	$Button/InfoPanel/VBoxContainer/MarginContainer2/VBoxContainer/Country.text = country
	$Button/InfoPanel/VBoxContainer/MarginContainer2/VBoxContainer/Birth.text = birth
	$Button/InfoPanel/VBoxContainer/MarginContainer2/VBoxContainer/Info.text = famous_for
	
	#Images
	$Button/VBoxContainer/TextureRect.texture = get_valid_guest_image(portrait)
	$Button/InfoPanel/VBoxContainer/MarginContainer/HBoxContainer/Image_1.texture = get_valid_guest_image(portrait)
	$Button/InfoPanel/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/Image_2.texture = get_valid_guest_image(image_1)
	$Button/InfoPanel/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/Image_3.texture = get_valid_guest_image(image_2)
	$Button/InfoPanel/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/Image_4.texture = get_valid_guest_image(image_3)

func get_valid_guest_image(image_path : String,):
	var _image_texture
	if SaveSystem.guest_image_as_texture(image_path):
		_image_texture = SaveSystem.guest_image_as_texture(image_path)
	else:
		_image_texture = load("res://Assets/Textures/no_image.jpg")
	return _image_texture
	
		
