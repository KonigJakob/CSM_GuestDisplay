extends Control

var tween
@export var tween_duration : float
@export var square : ColorRect

# Called when the node enters the scene tree for the first time.
func _ready():
	animate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func animate():
	tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(square, "size", Vector2(100,100), tween_duration)
	tween.tween_property(square, "color", Color.RED, tween_duration)
	tween.set_parallel(false)
	tween.tween_callback(debug_stuff)
	
func debug_stuff():
	print(square.size)
