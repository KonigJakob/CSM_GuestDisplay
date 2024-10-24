extends Timer

@export var min_wait_time : float
@export var max_wait_time : float

var random_wait_time : float
var rng = RandomNumberGenerator.new()

func _on_timeout():
	random_wait_time = rng.randf_range(min_wait_time, max_wait_time)
	wait_time = random_wait_time
