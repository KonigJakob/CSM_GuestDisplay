extends Node

const csv_filepath : String = "user://CSM_GuestDisplay_Localization.csv"
var translation : Translation
var data

func _ready():
	load_translation()

func import_csv_file():
	if FileAccess.file_exists(csv_filepath):
		var csv = FileAccess.open(csv_filepath, FileAccess.READ)
		if csv:
			while csv.get_position() < csv.get_length():
				data = csv.get_csv_line()
		else:
			print("Error loading CSV File at ", csv_filepath)
	else:
		print("File does not exist!")
	print(data)

func load_translation() -> void:
	import_csv_file()

