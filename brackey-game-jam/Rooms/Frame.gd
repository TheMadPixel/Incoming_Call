extends Button

@export var interaction_range := 150.0
@export_multiline var inspect_text := "That’s me... Daniel... and Maya."


func _ready():

	if Global.picture_frame_removed:
		visible = false

	gui_input.connect(_on_gui_input)


func _on_gui_input(event):

	if event is InputEventMouseButton and event.pressed:

		if event.button_index != MOUSE_BUTTON_RIGHT:
			return

		var player = get_tree().get_first_node_in_group("player")

		if player == null:
			return

		var distance := global_position.distance_to(
			player.global_position
		)

		if distance > interaction_range:
			return

		player.inspect_object(inspect_text)
