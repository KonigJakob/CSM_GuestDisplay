extends HBoxContainer

func _on_memory_game_successful_sequence():
	$LeaderboardOldest.text = $LeaderboardOld.text
	$LeaderboardOld.text = $LeaderboardNew.text
	$LeaderboardNew.text = $"../Timer".text
	
	
