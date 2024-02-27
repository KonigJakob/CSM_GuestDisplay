Adding Famous Guest Info to JSON:
	- Use Last name in all caps for GuestID.
		- If there are two guests with the same last name, put the first letter of their first name before the last name.
			Example: 	Ralph H. Baer --> BAER
						Brenda Romero --> BROMERO
						John Romero --> JROMERO
	- Put Date of birth and death on the same space linked by a dash (-).
	- Use the GuestID in the "famous for" field. Add the corresponding text on the CSM_GuestDisplay_Localization.csv file.

Adding Famous Guest Images:
	- Save images in FamousGuests_Resources/Images folder
	- Images must be named using the Guest ID (Last name in CAPS) and a number (1-4).
		Example: BAER1, BAER2, BAER3
	- Images must be saved as .png
	- To correctly display them,
		Image1: Portrait (300x400)
		Image2-4: Landscape (300x400)

Adding Famous Guest Translation Text:
	- Edit the CSM_GuestDisplay_Localization.csv. Any Spreadsheet apps can be used.
	- Enclose text within quotation marks ("").
	- Use the GuestID as key.
		Example: BAER,"He developed the Brown Box.","Er hat die Brown Box entwickelt."
	- If editing the file externally, don't forget to replace the existing file.

Copy and paste this folder in:
	Windows: %APPDATA%\Godot\app_userdata\CSM_GuestDisplay
	MAC: ~/Library/Application Support/Godot/app_userdata/CSM_GuestDisplay
	Linux: ~/.local/share/godot/app_userdata/CSM_GuestDisplay
