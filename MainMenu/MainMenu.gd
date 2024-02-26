extends Control

func _on_button_famous_guests_pressed():
	SceneManager.target_scene = "res://FamousGuests/FamousGuests.tscn"
	get_tree().change_scene_to_file("res://UI_Details/LoadingScene.tscn")

func _on_button_guest_book_pressed():
	SceneManager.target_scene = "res://GuestBook/GuestBook.tscn"
	get_tree().change_scene_to_file("res://UI_Details/LoadingScene.tscn")
