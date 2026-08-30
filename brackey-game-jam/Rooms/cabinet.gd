extends Button

@export_multiline var dialogue_line := ""
@export_multiline var special_dialogue_line := ""

var is_special := false
var player


func _ready():

	player = get_tree().get_first_node_in_group("player")

	pressed.connect(_on_pressed)


func set_special(value: bool):

	is_special = value


func _on_pressed():

	if not Global.can_use_buttons:
		return

	if player == null:
		player = get_tree().get_first_node_in_group("player")

	if player == null:
		return

	if is_special:

		player.show_speech(
			special_dialogue_line,
			3.0,
			Color.WHITE
		)

		Global.special_button_found = true

	else:

		player.show_speech(
			dialogue_line,
			3.0,
			Color.WHITE
		)
