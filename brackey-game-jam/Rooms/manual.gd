extends Button

@export var interaction_range := 150.0

@onready var sprite: Sprite2D = $Sprite2D

var inspecting := false


func _ready():
	update_manual()

	gui_input.connect(_on_gui_input)


func update_manual():

	if Global.has_manual:
		visible = false
		return

	if Global.manual_available:
		visible = true
	else:
		visible = false


func _on_gui_input(event: InputEvent):

	if event is InputEventMouseButton and event.pressed:

		var player = get_tree().get_first_node_in_group("player")

		if player == null:
			return

		var distance := global_position.distance_to(
			player.global_position
		)

		if distance > interaction_range:
			return


		# LEFT CLICK = pick up manual
		if event.button_index == MOUSE_BUTTON_LEFT:

			if Global.manual_available and not Global.has_manual:
				Global.has_manual = true
				visible = false


		# RIGHT CLICK = inspect manual
		elif event.button_index == MOUSE_BUTTON_RIGHT:

			if not inspecting:
				inspect_manual(player)


func inspect_manual(player):

	inspecting = true

	var dialogue = [
		"It's an instructions manual for a radio.",
		"A frequency is marked in red.",
		"107.6 MHz",
	]

	for line in dialogue:

		player.show_speech(
			line,
			3.0
		)

		await get_tree().create_timer(3.0).timeout

	inspecting = false
