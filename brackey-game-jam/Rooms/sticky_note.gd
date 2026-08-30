extends Button

@export var interaction_range := 150.0

var inspecting := false


func _ready():
	gui_input.connect(_on_gui_input)


func _on_gui_input(event: InputEvent):

	if event is InputEventMouseButton and event.pressed:

		# RIGHT CLICK ONLY
		if event.button_index != MOUSE_BUTTON_RIGHT:
			return

		if inspecting:
			return

		var player = get_tree().get_first_node_in_group("player")

		if player == null:
			return

		var distance := global_position.distance_to(
			player.global_position
		)

		if distance > interaction_range:
			return

		inspect_note(player)


func inspect_note(player):

	inspecting = true

	# First line
	player.show_speech(
		"It's a sticky note.",
		3.0
	)

	await get_tree().create_timer(3.0).timeout

	# Second line
	player.show_speech(
		'It says "Don\'t trust what you hear".',
		3.0
	)
	
	await get_tree().create_timer(3.0).timeout

	# Second line
	player.show_speech(
		"The handwriting seems familiar.",
		3.0
	)
	await get_tree().create_timer(3.0).timeout

	inspecting = false
