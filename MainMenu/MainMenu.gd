extends Control

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
