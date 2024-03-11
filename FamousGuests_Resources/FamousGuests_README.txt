FAMOUS GUESTS

Adding Famous Guest Info to JSON:
	
	Found in %APPDATA%\Godot\app_userdata\CSM_GuestDisplay\FamousGuests_Resources\
	
	- Use Last name in all caps for GuestID.
		- If there are two guests with the same last name, put the first letter of their first name before the last name.
			Example: 	Ralph H. Baer --> BAER
						Brenda Romero --> BROMERO
						John Romero --> JROMERO
	- Put Date of birth and death on the same space linked by a dash (-).
	- In "Famous for" type German text before English text.
	- Due to JSON encoding and decoding limitations of Godot on Windows, special German symbols must be typed as such:
		ä -> [&auml;]
		Ä -> [&Auml;]
		ö -> [&ouml;]
		Ö -> [&Ouml;]
		ü -> [&uuml;]
		Ü -> [&Uuml;]
		ß -> [&szlig;]
		Example:	Mitgründer von Atari. -> Mitgr[&uuml;]nder von Atari.

Adding Famous Guest Images:
	
	Add to: Found in %APPDATA%\Godot\app_userdata\CSM_GuestDisplay\FamousGuests_Resources\Images\
	
	- Images must be named using the Guest ID (Last name in CAPS) and one of four identifiers (Portrait, Image1, Image2, or Image3).
		Example: BAER1, BAER2, BAER3
	- Images must be saved as .png or .jpg
	- To correctly display images, they must be saved with the following resolutions:
		Portrait 1080 x 1350 
		Image2-3 1080 x 566

GUEST BOOK

	Answers saved in %APPDATA%\Godot\app_userdata\CSM_GuestDisplay\GuestAnswers as JSON.
	
	- Answers consist of:
		- Guest ID
		- Satisfaction level (0-5)
		- Age group
		- First language
		- Message
	- It is possible for guests to leave information blank.
	- All answers from the same day are saved in a single JSON file automatically.
	- JSON files can be converted to spreadsheets using tools such as https://data.page/json/csv
	
