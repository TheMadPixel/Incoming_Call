extends AnimatedSprite2D

@export var rotation_amount := 5.0
@export var vibration_speed := 30.0
@export var interaction_range := 150.0
@export_multiline var inspect_text := "Someone  is  calling.  I  should  pick  it  up."

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready():
	if Global.has_phone:
		queue_free()
		return
	
	play("vibrate")


func _process(_delta):
	rotation_degrees = (
		sin(Time.get_ticks_msec() / 1000.0 * vibration_speed)
		* rotation_amount
	) + 75


func _on_phone_int_box_pressed():
	var player = get_tree().get_first_node_in_group("player")

	if player == null:
		return

	var distance = global_position.distance_to(player.global_position)

	if distance > interaction_range:
		return

	Global.has_phone = true

	queue_free()


func _on_phone_int_box_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:

			var player = get_tree().get_first_node_in_group("player")

			if player == null:
				return

			var distance = global_position.distance_to(player.global_position)

			if distance > interaction_range:
				return

			player.inspect_object(inspect_text)
