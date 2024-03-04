extends Control

var tween
var starting_position : Vector2
@export var tween_duration : float
@export var square1 : ColorRect
var rng

func _ready():
	rng = RandomNumberGenerator.new()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func animate(square):
	tween = get_tree().create_tween().set_parallel(true)
	var randomX = rng.randf_range(-50,50)
	var randomY = rng.randf_range(-50,50)
	tween.tween_property(square, "size", Vector2(rng.randf_range(5,50),rng.randf_range(5,50)), tween_duration)
	tween.tween_property(square, "color", Color.RED, tween_duration)
	tween.tween_property(square, "position", square.position + Vector2(randomX, randomY),tween_duration)
	tween.set_parallel(false)
	tween.tween_property(square,"position:y", square.position.y + 50, tween_duration)
	tween.tween_property(square, "modulate:a", 0, tween_duration)

func _input(event):
	if event is InputEventMouseButton:
		starting_position = event.position
		create_squares()

func create_squares():
	var random_number = rng.randi_range(1,6)
	for n in random_number:
		var square = ColorRect.new()
		add_child(square)
		square.size = Vector2.ZERO
		square.color = Color.WHITE
		square.position = starting_position + Vector2(rng.randf_range(0,30),rng.randf_range(0,30))
		animate(square)
