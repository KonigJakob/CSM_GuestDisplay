extends Control

var loading_status : int
var progress : Array[float]
@export var logo : TextureRect

@onready var progress_bar : TextureProgressBar = $TextureProgressBar
@onready var loading_message : Label = $Label

func _ready():
	SceneManager.target_scene_changed.connect(on_target_scene_changed)
	ResourceLoader.load_threaded_request(SceneManager.target_scene)
	progress_bar.position = Vector2(get_viewport_rect().size.x/2 - progress_bar.size.x/2, get_viewport_rect().size.y/2 - progress_bar.size.y/2)
	loading_message.position = Vector2(get_viewport_rect().size.x/2 - loading_message.size.x/2, progress_bar.position.y + progress_bar.size.y + 70)

func _process(_delta):
	if SceneManager.target_scene:
		loading_status = ResourceLoader.load_threaded_get_status(SceneManager.target_scene, progress)
	
		match loading_status:
			ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				progress_bar.value = progress[0] * 100
				
			ResourceLoader.THREAD_LOAD_LOADED:
				get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(SceneManager.target_scene))
			ResourceLoader.THREAD_LOAD_FAILED:
				print("Couldn't load scene.")
	else:
		print("No scene file path.")

func on_target_scene_changed():
	pass
