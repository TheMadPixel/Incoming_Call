extends Button

@export_file("*.tscn") var next_level: String

@export var door_id := ""
@export var next_entrance := ""

@export var interaction_range := 150.0

@export_multiline var inspect_text := "That's the door."

@export_multiline var locked_text := "It's locked."


@onready var door_position: Marker2D = $DoorPosition


var locked := false


func _ready():

	add_to_group("doors")

	gui_input.connect(_on_gui_input)


func _on_pressed():

	var player = get_tree().get_first_node_in_group("player")

	if player == null:
		return


	var distance := door_position.global_position.distance_to(
		player.global_position
	)


	if distance > interaction_range:
		return


	if locked:

		player.inspect_object(locked_text)

		return


	if next_level == "":
		return


	Global.spawn_point = next_entrance

	await Transition.fade_to_black()

	get_tree().change_scene_to_file(next_level)


func _on_gui_input(event: InputEvent):

	if event is InputEventMouseButton:

		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:

			var player = get_tree().get_first_node_in_group("player")

			if player == null:
				return


			var distance := door_position.global_position.distance_to(
				player.global_position
			)


			if distance > interaction_range:
				return


			player.inspect_object(inspect_text)


func toggle_lock():

	locked = !locked

	print("Door locked: ", locked)


	if locked:

		Global.bedroom_door_is_locked = true

		Global.bedroom_door_locked.emit()

	else:

		Global.bedroom_door_is_locked = false
