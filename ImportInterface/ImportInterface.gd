extends Control

const famous_guests_resource_folder_path : String = "res://FamousGuests_Resources/Images"

var portrait = false
var other_image = false

var texture_rects
var current_rect : TextureRect
var line_edits

var guest_name : String
var guest_country : String
var guest_dates : String
var guest_info : String
var guest_id : String
@export var guest_id_edit : LineEdit

# Called when the node enters the scene tree for the first time.
func _ready():
	texture_rects = get_tree().get_nodes_in_group("texture_rects")
	line_edits = get_tree().get_nodes_in_group("line_edits")
	signal_connect()
	get_viewport().files_dropped.connect(on_files_dropped)
	load_images_from_folder("user://FamousGuests_Resources/Images")

func signal_connect():
	for tr in texture_rects:
		tr.mouse_entered.connect(_on_mouse_entered_id.bind(tr))
		tr.mouse_exited.connect(_on_mouse_exited_id.bind(tr))
	for le in line_edits:
		le.text_changed.connect(_on_text_changed_id.bind(le))

func on_files_dropped(files):
	if portrait || other_image:
		var ext = files[0].get_extension()
		var file_name = files[0].get_file()
		if ext == "png" || "jpg" || "webp":
			print("File is an image")
			if portrait:
				var image = Image.new()
				image.load(files[0])
				resize_image(image, "Portrait")
				image.save_jpg("user://FamousGuests_Resources/Images/" + file_name)
				var tex = ImageTexture.create_from_image(image)
				current_rect.texture = tex
			elif other_image:
				var image = Image.new()
				image.load(files[0])
				resize_image(image, "Other")
				image.save_jpg("user://FamousGuests_Resources/Images/" + file_name)
				var tex = ImageTexture.create_from_image(image)
				current_rect.texture = tex
		else:
			print("File is not a supported image.")

func load_images_from_folder(path) -> Array:
	var loaded_images = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
				var ext = file_name.get_extension()
				if ext == "png" || "jpg" || "webp":
					var image = Image.new()
					var error = image.load("user://FamousGuests_Resources/Images/" + file_name)
					if error:
						print("Couldn't load image.")
					else:
						var image_texture = ImageTexture.create_from_image(image)
						loaded_images.append(image_texture)
				else: 
					print("No images found.")
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("An error occurred when trying to access the path.")
	return loaded_images

func resize_image(image : Image, image_size : String) -> void:
	if image_size == "Portrait":
		image.resize(1080, 1350)
	elif image_size == "Other":
		image.resize(1080, 566)
	else:
		print("Image size not specified.")

func _on_portrait_rect_mouse_entered():
	portrait = true
	print(portrait)
func _on_portrait_rect_mouse_exited():
	portrait = false
	print(portrait)

	
func _on_mouse_entered_id(rect):
	print("Entered: ", rect)
	current_rect = rect
	if rect.name.contains("IMAGE"):
		other_image = true
	elif rect.name.contains("PORTRAIT"):
		portrait = true

func _on_mouse_exited_id(rect):
	print("Exited: ", rect)
	current_rect = null
	if rect.name.contains("IMAGE"):
		other_image = false
	elif rect.name.contains("PORTRAIT"):
		portrait = false

func _on_text_changed_id(new_text, line):
	print("Text changed")
	if line.name.contains("NAME"):
		guest_name = new_text
		guest_id = guest_name.get_slice(" ", 1).to_upper().insert(0,"_")
		guest_id_edit.text = guest_id
		print(guest_id)
	elif line.name.contains("COUNTRY"):
		guest_country = new_text
	elif line.name.contains("DATES"):
		guest_dates = new_text
	elif line.name.contains("INFO"):
		guest_info = new_text
	elif line.name.contains("ID"):
		guest_id = new_text.insert(0,"_")

func add_new_guest():
	for le in line_edits:
		if le.text != "":
			
		else:
			print("Information missing!")
		

func _on_button_pressed():
	pass # Replace with function body.
