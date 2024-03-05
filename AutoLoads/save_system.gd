extends Node

@onready var save_data_filepath = new_data_file()
var file_name_dated : String
var date : String

var guest_data_filepath : String = "user://FamousGuests_Resources/famous_guests.json"
var guest_images_folder_path : String = "user://FamousGuests_Resources/Images/"
var placeholder_image : String = "res://Assets/Textures/no_image.jpg"
var number_of_guests : int

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

func load_images_from_folder(folder_path : String, file_paths : bool) -> Array:
	var loaded_images = []
	var dir = DirAccess.open(folder_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
				if file_paths:
					loaded_images.append("user://FamousGuests_Resources/Images/" + file_name)
				else:
					var ext = file_name.get_extension()
					if ext == "png" || "jpg" || "webp" || "jpeg":
						var image = Image.new()
						var error = image.load("user://FamousGuests_Resources/Images/" + file_name)
						if error:
							print("Couldn't load image.")
						else:
							loaded_images.append(error)
							print(loaded_images)
					else: 
						print("No images found.")
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("An error occurred when trying to access the path.")
	return loaded_images

func load_guest():
	if FileAccess.file_exists(guest_data_filepath):
		var file = FileAccess.open(guest_data_filepath, FileAccess.READ)
		var json = JSON.new()
		var error = json.parse(file.get_as_text())
		if error == OK:
			var saved_data = json.data
			if typeof(saved_data) == TYPE_DICTIONARY:
				#print(saved_data) # Prints dictionary
				number_of_guests = saved_data.size()
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

func add_guest(guest_info : String):
	if FileAccess.file_exists(guest_data_filepath):
		var file = FileAccess.open(guest_data_filepath, FileAccess.READ_WRITE)
		file.seek_end(-2)
		file.store_string(",")
		print(guest_info)
		var guest_info_trimmed = guest_info.trim_prefix("{").trim_suffix("}")
		file.store_string(guest_info_trimmed)
		file.store_string("}")
		file = null
	else:
		print("Guest file does not exist!")

func assign_images(guests : Dictionary) -> Dictionary:
	var guest_images = load_images_from_folder(guest_images_folder_path, true)
	for g in guests:
		print("Guest: " + g)
		for i in guest_images:
			var i_trimmed = i.get_file()
			if guests[g]["GuestID"] in i_trimmed:
				if "1" in i_trimmed:
					guests[g]["Image 1"] = i
					print("Image found: " + i)
				else:
					guests[g]["Image 1"] = placeholder_image
					print("Image 1 for " + guests[g]["GuestID"] + " not found.")
				if "2" in i_trimmed:
					guests[g]["Image 2"] = i
				else:
					guests[g]["Image 2"] = placeholder_image
					print("Image 2 for " + guests[g]["GuestID"] + " not found.")
				if "3" in i_trimmed:
					guests[g]["Image 3"] = i
				else:
					guests[g]["Image 3"] = placeholder_image
					print("Image 3 for " + guests[g]["GuestID"] + " not found.")
				if "PORTRAIT" in i_trimmed:
					guests[g]["Portrait"] = i
				else:
					guests[g]["Portrait"] = placeholder_image
					print("Portrait for " + guests[g]["GuestID"] + " not found.")
			else:
				print("No images found for " + guests[g]["GuestID"])
				continue
	return guests

func guest_image_as_texture(path : String) -> ImageTexture:
	var image = Image.new()
	var loaded_texture
	var error = image.load(path)
	if error:
		print("Couldn't load image: " + path)
	else:
		loaded_texture = ImageTexture.create_from_image(image)
	return loaded_texture
