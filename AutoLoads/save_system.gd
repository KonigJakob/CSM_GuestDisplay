extends Node

@onready var save_data_filepath = new_data_file()
var file_name_dated : String
var date : String

var guest_data_filepath : String = "user://famous_guests.json"


func _process(_delta):
	if Input.is_action_pressed("exit"):
		save_on_exit()
		get_tree().quit()
		
func new_data_file():
	date = Time.get_date_string_from_system()
	var new_file = "user://" + date + "-" + "poll-data.json"
	return new_file

func save(content):
	if FileAccess.file_exists(save_data_filepath):
		var file = FileAccess.open(save_data_filepath, FileAccess.READ_WRITE)
		file.seek_end()
		file.store_string(content)
		file.store_string(",")
		print(file.get_path_absolute())
		file = null
	else:
		var file = FileAccess.open(save_data_filepath, FileAccess.WRITE)
		print("Creating data file")
		file.store_string("[{\"participants\": [")
		file.store_string(content)
		file.store_string(",")
		print(file.get_path_absolute())
		file = null
	
func load_guest_data():
	if FileAccess.file_exists(save_data_filepath):
		var file = FileAccess.open(save_data_filepath, FileAccess.READ)
		var json = JSON.new()
		var error = json.parse(file.get_as_text())
		if error == OK:
			var saved_data = json.data
			if typeof(saved_data) == TYPE_ARRAY:
				print(saved_data) # Prints array
			else:
				print("Unexpected data")
		else:
			print("JSON Parse Error: ", json.get_error_message(), " in ", file.get_as_text(), " at line ", json.get_error_line())
	else:
		print("File does not exist!")

func load_guest():
	if FileAccess.file_exists(guest_data_filepath):
		var file = FileAccess.open(guest_data_filepath, FileAccess.READ)
		var json = JSON.new()
		var error = json.parse(file.get_as_text())
		if error == OK:
			var saved_data = json.data
			if typeof(saved_data) == TYPE_DICTIONARY:
				#print(saved_data) # Prints dictionary
				return(saved_data)
			else:
				print("Unexpected data")
		else:
			print("JSON Parse Error: ", json.get_error_message(), " in ", file.get_as_text(), " at line ", json.get_error_line())
	else:
		print("File does not exist!")
	
func save_on_exit():
	var dummy_data = "{\"Dummy\": \"dummy\"}"
	var file = FileAccess.open(save_data_filepath, FileAccess.READ_WRITE)
	file.seek_end()
	file.store_string(dummy_data)
	file.store_string("]}]")
	print(file.get_path_absolute())
	file = null
