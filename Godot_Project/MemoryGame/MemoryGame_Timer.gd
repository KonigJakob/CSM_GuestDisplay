extends Label

var time_elapsed : float = 0
var count_time : bool = true

func _process(delta):
	if count_time:
		time_elapsed += delta
		text = "%.1f" % time_elapsed
	
func restart_time():
	time_elapsed = 0
	
func start_stopwatch():
	count_time = true

func stop_stopwatch():
	count_time = false
	restart_time()
	

