extends Node2D

@export var buttons: Array[Button]


func _ready():

	if buttons.is_empty():
		return

	if not Global.special_button_selected:

		Global.special_button_index = randi_range(
			0,
			buttons.size() - 1
		)

		Global.special_button_selected = true

		print(
			"SPECIAL BUTTON INDEX: ",
			Global.special_button_index
		)

	for i in range(buttons.size()):

		var button = buttons[i]

		if button.has_method("set_special"):
			button.set_special(
				i == Global.special_button_index
			)

		button.disabled = not Global.can_use_buttons

	if not Global.buttons_unlocked.is_connected(_on_buttons_unlocked):
		Global.buttons_unlocked.connect(_on_buttons_unlocked)


func _on_buttons_unlocked():

	for button in buttons:

		if is_instance_valid(button):
			button.disabled = false
