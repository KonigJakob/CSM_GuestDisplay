# CSM Guest Display

CSM Guest Display is an app to showcase famous guests that have visited the Computerspielemuseum in Berlin and survey regular visitors about their experience. Survey data can be retrieved to gather metrics about visitors such as age and first language. The app is meant to be used on a touch screen at the Computerspielemuseum main exhibit.

CSM Guest Display was created using the Godot Engine by Jaime Emilio O'Hea Flores as part of an Internship for the Game Design BA at HTW Berlin in 2024.

### Github

The whole project can be found in Github (https://github.com/KonigJakob/CSM_GuestDisplay.git). Updates will be distributed to the main branch.

## Setup

The user must create three folders within Godot's default user:// folder (%APPDATA%\Godot\app_userdata\CSM_GuestDisplay\).

### GuestAnswers

CSM Guest display will save survey answers here as JSON files.

### FamousGuests_Resources

- Store the Famous Guests JSON file here.
- Create and "Images" folder in here.

### FamousGuests_Resources/Images

- Store all Famous Guest images as described below.

## FAMOUS GUESTS

### Adding Famous Guest Info to JSON

- The JSON File can be found in: %APPDATA%\Godot\app_userdata\CSM_GuestDisplay\FamousGuests_Resources\

- Use Last name in all caps for GuestID.
- If there are two guests with the same last name, put the first letter of their first name before the last name.
			Example: 	Ralph H. Baer --> BAER
						Brenda Romero --> BROMERO
						John Romero --> JROMERO
- Put Date of birth and death on the same space linked by a dash (-).
- In "Famous for" type German text before English text.
- German and English texts are separated by three line breaks ("\n").
- Due to JSON encoding and decoding limitations of Godot on Windows, special German symbols must be typed as such:

		ä -> [&auml;]
		Ä -> [&Auml;]
		ö -> [&ouml;]
		Ö -> [&Ouml;]
		ü -> [&uuml;]
		Ü -> [&Uuml;]
		ß -> [&szlig;]

		Example:	Mitgründer von Atari. -> Mitgr[&uuml;]nder von Atari.


### Adding Famous Guest Images

- Save images in:
%APPDATA%\Godot\app_userdata\CSM_GuestDisplay\FamousGuests_Resources\Images\
	
- Images must be named using the Guest ID (Last name in CAPS) and one of four identifiers (Portrait, Image1, Image2, or Image3).

		Example: BAER_Image1, BAER_Image2, BAER_Image3, BEAR_Portrait

- Images must be saved as .png or .jpg
- To correctly display images, they must be saved with the following resolutions:

		Portrait 1080 x 1350 
		Image2-3 1080 x 566

## GUEST BOOK

### Retrieving Answers

- Answers saved in: %APPDATA%\Godot\app_userdata\CSM_GuestDisplay\GuestAnswers as JSON.
	
- Answers consist of:

		- Guest ID
		- Satisfaction level (0-5)
		- Age group
		- First language
		- Message

- It is possible for guests to leave information blank.
- All answers from the same day are saved in a single JSON file automatically.

- JSON files can be converted to spreadsheets using tools such as https://data.page/json/csv

## Credits

Created by Jaime Emilio O'Hea Flores

2024

Contact: jaemlo@gmail.com

## License

[MIT](https://choosealicense.com/licenses/mit/)
