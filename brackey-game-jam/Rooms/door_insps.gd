extends Node2D

@export var interaction_range := 10000
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export_multiline var inspect_text := "I  can't  go  outside  with  this  bad  weather."





func _on_window_insp_box_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:

			print("RIGHT CLICK DETECTED")

			var player = get_tree().get_first_node_in_group("player")

			if player == null:
				print("PLAYER NOT FOUND")
				return

			print("PLAYER FOUND")
			print("Distance: ", global_position.distance_to(player.global_position))

			var distance = global_position.distance_to(player.global_position)

			if distance > interaction_range:
				print("TOO FAR")
				return

			print("INSPECTING: ", inspect_text)

			player.inspect_object(inspect_text)
