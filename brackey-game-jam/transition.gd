extends CanvasLayer

var fade_rect: ColorRect


func _ready():
	layer = 100

	fade_rect = ColorRect.new()
	fade_rect.color = Color.BLACK
	fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fade_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	add_child(fade_rect)

	fade_rect.modulate.a = 0.0


func fade_to_black():
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(fade_rect, "modulate:a", 1.0, 0.5)
	await tween.finished


func fade_from_black():
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(fade_rect, "modulate:a", 0.0, 0.5)
	await tween.finished


func fade_from_black_slow():
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(fade_rect, "modulate:a", 0.0, 5.0)
	await tween.finished
