class_name button_syled

extends Control

signal child_button_pressed

@export var button_color : Color
var button_pos

func _ready():
	modulate = button_color
	button_pos = $Button.position

func _on_button_button_down():
	$Button.position = $Shadow.position

func _on_button_button_up():
	pass

func _on_button_pressed():
	child_button_pressed.emit()
	
func toggle_pressed():
	$Button.button_pressed = false

func _on_button_toggled(button_pressed):
	if !button_pressed:
		$Button.position = button_pos
