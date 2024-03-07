extends Control

class_name Guest

signal info_panel_changed(new_value : bool)


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

var info_panel_shown : bool : 
	set(value):
		if value != info_panel_shown:
			info_panel_shown = value
			info_panel_changed.emit(info_panel_shown)

@export var info_panel : Control
@export var button : Button
@export var container : VBoxContainer

func _ready():
	portrait_panel = get_parent()
	button.size = portrait_panel.size
	container.size = portrait_panel.size
	$Button/InfoPanel.panel_opened.connect(_on_panel_opened)
	$Button/InfoPanel.panel_closed.connect(_on_panel_closed)

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
	$Button/InfoPanel/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/Image_2.texture = get_valid_guest_image(image_1,1)
	$Button/InfoPanel/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/Image_3.texture = get_valid_guest_image(image_2,2)
	$Button/InfoPanel/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/Image_4.texture = get_valid_guest_image(image_3,3)

func get_valid_guest_image(image_path : String, _image_number : int = 0):
	var _image_texture
	if SaveSystem.guest_image_as_texture(image_path):
		_image_texture = SaveSystem.guest_image_as_texture(image_path)
	else:
		if _image_number == 1:
			$Button/InfoPanel/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/Image_2.visible = false
		if _image_number == 2:
			$Button/InfoPanel/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/Image_3.visible = false
		if _image_number == 3:
			$Button/InfoPanel/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/Image_4.visible = false
		else:
			_image_texture = load("res://Assets/Textures/no_image.jpg")
	return _image_texture
	
func _on_panel_opened():
	info_panel_shown = true
	
func _on_panel_closed():
	info_panel_shown = false
