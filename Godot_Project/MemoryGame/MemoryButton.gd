extends Button

signal game_button_up

@onready var color_rect = $ColorRect
var color_rect_color

func _on_button_down():
	var tween = get_tree().create_tween()
	tween.tween_property(color_rect, "scale", Vector2(0.7,0.7), 0.1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)

func _on_button_up():
	var tween = get_tree().create_tween()
	tween.tween_property(color_rect, "scale", Vector2(1.1,1.1), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(color_rect, "scale", Vector2(1,1), 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
