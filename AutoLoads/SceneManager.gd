extends Node

signal target_scene_changed(new_val : String)

var target_scene : String : 
	set(value):
		if value != target_scene:
			target_scene = value
			target_scene_changed.emit(target_scene)

func set_language(language : String) -> void: 
	TranslationServer.set_locale(language)


