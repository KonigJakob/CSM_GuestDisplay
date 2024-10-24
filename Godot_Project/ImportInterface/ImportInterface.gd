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
var guest_dictionary = {}
@export var guest_id_edit : LineEdit

# Called when the node enters the scene tree for the first time.
func _ready():
	SaveSystem.load_guest()
	texture_rects = get_tree().get_nodes_in_group("texture_rects")
	line_edits = get_tree().get_nodes_in_group("line_edits")
	signal_connect()
	get_viewport().files_dropped.connect(on_files_dropped)

func signal_connect():
	for t in texture_rects:
		t.mouse_entered.connect(_on_mouse_entered_id.bind(t))
		t.mouse_exited.connect(_on_mouse_exited_id.bind(t))
	for le in line_edits:
		le.text_changed.connect(_on_text_changed_id.bind(le))

func on_files_dropped(files):
	print("Portrait: ", portrait, "|Image: ", other_image)
	if portrait || other_image:
		var ext = files[0].get_extension()
		var file_name = files[0].get_file()
		if ext == "png" || "jpg" || "webp":
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
	#print("Entered: ", rect)
	current_rect = rect
	if rect.name.contains("IMAGE"):
		other_image = true
		print("Entered.")
	elif rect.name.contains("PORTRAIT"):
		portrait = true
		print("Entered.")
func _on_mouse_exited_id(rect):
	#print("Exited: ", rect)
	current_rect = null
	if rect.name.contains("IMAGE"):
		print("Exited.")
		other_image = false
	elif rect.name.contains("PORTRAIT"):
		portrait = false
		print("Exited.")

func _on_text_changed_id(new_text : String, line):
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

func update_dictionary() -> Dictionary:
	guest_dictionary = {"guest_" + str(SaveSystem.number_of_guests): { "GuestID": guest_id, "Name": guest_name, "Country": guest_country, "Birth": guest_dates, "Famous for": guest_info, "Portrait": "", "Image 1": "", "Image 2": "", "Image 3": ""}}
	return guest_dictionary

func add_new_guest(new_guest : Dictionary):
	var JSON_string = JSON.stringify(new_guest, "\t")
	SaveSystem.add_guest(JSON_string)

func _on_button_pressed():
	var complete_info : bool = true
	for l in line_edits:
		if l.text == "":
			complete_info = false
			print("Information missing! Check: " + l.name)
	if complete_info:
		var new_guest_info = update_dictionary()
		add_new_guest(new_guest_info)
	
