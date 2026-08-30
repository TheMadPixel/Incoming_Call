extends AnimatedSprite2D

@onready var color_rect: ColorRect = $ColorRect
@onready var light_switch: AnimatedSprite2D = $"."
signal light_turned_off
@export var interaction_range := 150.0

func _ready():
	if Global.bedroom_light == false:
		light_switch.play("off")
		color_rect.visible = true
		light_turned_off.emit()
	if Global.bedroom_light == true:
		light_switch.play("on")
		color_rect.visible = false

func _on_light_switch_int_box_pressed() -> void:
	var player = get_tree().get_first_node_in_group("player")

	if player == null:
		return

	var distance = global_position.distance_to(player.global_position)

	if distance > interaction_range:
		return

	Global.bedroom_light = !Global.bedroom_light

	if Global.bedroom_light:
		light_switch.play("on")
		color_rect.visible = false
	else:
		light_switch.play("off")
		color_rect.visible = true
		light_turned_off.emit()
