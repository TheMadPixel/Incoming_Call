extends Button

@export var interaction_range := 150.0
@export_multiline var inspect_text := "It's a power box."

@onready var flicker: ColorRect = $Flicker

var player
var fixed := false
var flickering := true


func _ready():

	player = get_tree().get_first_node_in_group("player")

	gui_input.connect(_on_gui_input)

	if Global.special_button_found:
		fixed = false
		flickering = true
		flicker_loop()
	else:
		flicker.visible = true
		flicker_loop()


func flicker_loop():

	while flickering:

		flicker.visible = randf() > 0.25

		await get_tree().create_timer(
			randf_range(0.05, 0.3)
		).timeout

	flicker.visible = false


func _on_gui_input(event):

	if event is InputEventMouseButton and event.pressed:

		if player == null:
			player = get_tree().get_first_node_in_group("player")

		if player == null:
			return

		var distance := global_position.distance_to(
			player.global_position
		)

		if distance > interaction_range:
			return

		# RIGHT CLICK = INSPECT
		if event.button_index == MOUSE_BUTTON_RIGHT:

			player.inspect_object(inspect_text)

		# LEFT CLICK = FIX LIGHTS
		elif event.button_index == MOUSE_BUTTON_LEFT:

			if not Global.special_button_found:
				return

			if fixed:
				return

			fix_lights()


func fix_lights():

	fixed = true

	flickering = false
	flicker.visible = false

	print("POWER BOX FIXED")
