extends Control

@export var localization_buttons : HBoxContainer
@export var logo : TextureRect
@export var welcome : Label

func _ready():
	localization_buttons.position.x = get_viewport_rect().size.x - localization_buttons.size.x - 35
	localization_buttons.position.y = get_viewport_rect().size.y - localization_buttons.size.y - 35
	logo.position = Vector2(get_viewport_rect().size.x/2 - logo.size.x/2, 100)
	welcome.position = Vector2(get_viewport_rect().size.x/2 - welcome.size.x/2, logo.position.y + logo.size.y + 70)

func _on_button_famous_guests_pressed():
	SceneManager.target_scene = "res://FamousGuests/FamousGuests.tscn"
	get_tree().change_scene_to_file("res://UI_Details/LoadingScene.tscn")

func _on_button_guest_book_pressed():
	SceneManager.target_scene = "res://GuestBook/GuestBook.tscn"
	get_tree().change_scene_to_file("res://UI_Details/LoadingScene.tscn")

func _on_translation_de_child_button_pressed():
	TranslationServer.set_locale("de")
func _on_translation_en_child_button_pressed():
	TranslationServer.set_locale("en")
