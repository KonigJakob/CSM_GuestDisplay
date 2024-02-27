extends Control

class_name Guest

var guest_id : String
var guest_name : String
var country : String
var birth : String
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
	if default_values:
		$VBoxContainer/TextureRect.texture = load("res://Assets/Textures/images.jpeg")
		$VBoxContainer/Label.text = "Miyamoto"
	else:
		pass

func _on_button_pressed():
	if info_panel.visible == false:
		info_panel.visible = true

func update_guest_info() -> void:
	$Button/VBoxContainer/PortraitName.text = guest_name
	$Button/VBoxContainer/TextureRect.texture = load(image_1)
	$Button/InfoPanel/VBoxContainer/MarginContainer2/VBoxContainer/Name.text = guest_name
	$Button/InfoPanel/VBoxContainer/MarginContainer2/VBoxContainer/Country.text = country
	$Button/InfoPanel/VBoxContainer/MarginContainer2/VBoxContainer/Birth.text = birth
	$Button/InfoPanel/VBoxContainer/MarginContainer2/VBoxContainer/Info.text = famous_for
	$Button/InfoPanel/VBoxContainer/MarginContainer/HBoxContainer/Image_1.texture = load(SaveSystem.guest_images_folder_path + guest_id + "1")
	$Button/InfoPanel/VBoxContainer/MarginContainer/HBoxContainer/Image_1.texture = load(SaveSystem.guest_images_folder_path + guest_id + "2")
