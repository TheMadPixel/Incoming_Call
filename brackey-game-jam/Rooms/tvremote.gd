extends Button

@export var interaction_range := 150.0

@export_multiline var inspect_text := "That wasn't there before..."

@onready var remote_sprite: Sprite2D = $Remote


func _ready():
	visible = Global.remote_available


func _gui_input(event: InputEvent):

	if not visible:
		return

	if event is InputEventMouseButton and event.pressed:

		var player = get_tree().get_first_node_in_group("player")

		if player == null:
			return

		var distance := global_position.distance_to(
			player.global_position
		)

		if distance > interaction_range:
			return

		if event.button_index == MOUSE_BUTTON_LEFT:

			if Global.has_remote:
				return

			Global.has_remote = true
			visible = false

		elif event.button_index == MOUSE_BUTTON_RIGHT:

			player.inspect_object(inspect_text)
