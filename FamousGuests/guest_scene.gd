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



func _ready():
	#$VBoxContainer/Label.text = guest_name
	#$TextureRect.texture = load(image_1)
	#if get_parent():
		#size = get_parent().get_size()
	pass
