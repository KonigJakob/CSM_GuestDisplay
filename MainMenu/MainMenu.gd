extends Control

func _on_button_famous_guests_pressed():
	get_tree().change_scene_to_file("res://FamousGuests/FamousGuests.tscn")

func _on_button_guest_book_pressed():
	get_tree().change_scene_to_file("res://GuestBook/GuestBook.tscn")
