class_name button_syled

extends Control

signal child_button_pressed

@export var button_color : Color
@export var button_text : String
@export var button_size : Vector2
@export var button_toggle_mode : bool = true
@export var button_pressed : bool = false

var button_pos

func _ready():
	$Button/CenterContainer/Label.text = button_text
	$Shadow.size = button_size
	$Button.size = button_size
	$Button/CenterContainer.size = button_size
	$Button.toggle_mode = button_toggle_mode
	modulate = button_color
	button_pos = $Button.position

func _on_button_button_down():
	$Button.position = $Shadow.position

func _on_button_button_up():
	pass

func _on_button_pressed():
	child_button_pressed.emit()
	button_pressed = !button_pressed
	
func toggle_pressed():
	$Button.button_pressed = false

func keep_pressed():
	$Button.button_pressed = true
	$Button.position = $Shadow.position

func _on_button_toggled(button_pressed):
	if !button_pressed:
		$Button.position = button_pos
