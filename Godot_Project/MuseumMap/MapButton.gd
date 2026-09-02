extends TextureButton

@export var sister_node : Control
@export var sister_button : Control

var info_panel : Control

var is_pressed : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	self.button_down.connect(_on_pressed)
	sister_button.button_down.connect(_on_pressed)
	
	var button_bitmap : BitMap = BitMap.new()
	button_bitmap.create_from_image_alpha(texture_normal.get_image())
	texture_click_mask = button_bitmap
	
	info_panel = $"../../InfoPanel"

func _on_pressed():
	if !is_pressed:
		is_pressed = true
		z_index = 10
		sister_node.z_index = 10
		var bounce_tween = get_tree().create_tween().set_loops(1)
		bounce_tween.tween_property(self, "position:y",position.y - 30, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
		bounce_tween.set_parallel()
		bounce_tween.tween_property(info_panel, "position:x", info_panel.position.x - 400, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
		$"../../DarkOverlay".visible = true
	elif is_pressed:
		is_pressed = false
		z_index = 0
		sister_node.z_index = 0
		var bounce_tween = get_tree().create_tween().set_loops(1)
		bounce_tween.tween_property(self, "position:y", position.y + 30, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
		bounce_tween.set_parallel()
		bounce_tween.tween_property(info_panel, "position:x", info_panel.position.x + 400, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
		$"../../DarkOverlay".visible = false
