extends Node

signal target_scene_changed(new_val : String)

var timer

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 60 * 3
	timer.one_shot = true
	timer.start()
	timer.timeout.connect(_on_timer_timeout)

func _input(event):
	if event.is_pressed():
		timer.start()

var target_scene : String : 
	set(value):
		if value != target_scene:
			target_scene = value
			target_scene_changed.emit(target_scene)

func _on_timer_timeout():
	if get_tree().current_scene.name == "Main":
		timer.start()
	elif get_tree().current_scene.name == "FamousGuests":
		timer.start()
	else:
		target_scene = "res://MainMenu/main.tscn"
		get_tree().change_scene_to_file("res://UI_Details/LoadingScene.tscn")
		timer.start()
		
func reparent_guests():
	for g in SaveSystem.guest_array:
		g.get_parent().remove_child(g)
