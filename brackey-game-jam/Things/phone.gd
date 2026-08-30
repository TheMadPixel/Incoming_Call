extends Control


@onready var phone: Control = $"."
@onready var time: Label = $Time
@onready var notif_1: ColorRect = $PhoneBg/Notif1
@onready var caller_label: Label = $PhoneBg/Notif1/CallerLabel
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var speech: Label = $Speech


@export var incoming_caller: Control
@export var incoming_caller_label: Label


var is_up := false
var original_position: Vector2
var current_call_id := ""

var speech_tween: Tween


func _ready():

	original_position = position

	phone.visible = false
	notif_1.visible = false

	if incoming_caller:
		incoming_caller.visible = false

	if not Global.has_phone_changed.is_connected(_on_has_phone_changed):
		Global.has_phone_changed.connect(_on_has_phone_changed)

	if not Global.call_available.is_connected(_on_call_available):
		Global.call_available.connect(_on_call_available)

	print("PHONE CONNECTED TO CALL SIGNAL")


func _process(_delta):

	if Global.has_phone:

		phone.visible = true

		time.text = Global.get_time_string()

	else:

		phone.visible = false


func is_main_menu() -> bool:

	var scene = get_tree().current_scene

	if scene == null:
		return true

	return scene.name == "MainMenu"


# ==========================================
# PHONE APPEARS
# ==========================================

func _on_has_phone_changed(value):

	if not value:

		phone.visible = false

		return


	phone.visible = true

	position = original_position

	is_up = true

	var target_position := original_position + Vector2(0, -155)

	var tween := create_tween()

	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(
		self,
		"position",
		target_position,
		0.5
	)


# ==========================================
# CALL AVAILABLE
# ==========================================

func _on_call_available():

	print("CALL AVAILABLE SIGNAL RECEIVED")


	if is_main_menu():

		print("CALL BLOCKED: MAIN MENU")

		return


	if current_call_id != "":

		print("CALL ALREADY ACTIVE: ", current_call_id)

		return


	current_call_id = Global.get_next_call()

	print("NEXT CALL: ", current_call_id)


	if current_call_id == "":

		print("NO CALL IN QUEUE")

		return


	var call_data = Global.calls[current_call_id]

	print("CALLER: ", call_data["caller"])


	caller_label.text = call_data["caller"]

	notif_1.visible = true

	audio_stream_player.play()

	print("NOTIFICATION SET VISIBLE: ", notif_1.visible)


# ==========================================
# PHONE BUTTON
# ==========================================

func _on_phone_pressed():

	is_up = !is_up

	var target_position := original_position

	if is_up:

		target_position += Vector2(0, -175)


	var tween := create_tween()

	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(
		self,
		"position",
		target_position,
		0.5
	)


# ==========================================
# ACCEPT CALL
# ==========================================

func _on_notif_1_accept_pressed():

	audio_stream_player.stop()


	if current_call_id == "":
		return


	var call_data = Global.calls[current_call_id]


	notif_1.visible = false


	if incoming_caller:

		incoming_caller.visible = true


	if incoming_caller_label:

		incoming_caller_label.text = call_data["caller"]


	# ==========================================
	# PLAY DIALOGUE
	# ==========================================

	await play_dialogue(
		call_data["text"],
		call_data["color"]
	)


	# ==========================================
	# HIDE CALLER
	# ==========================================

	if incoming_caller:

		incoming_caller.visible = false


	# ==========================================
	# CALL 2
	# ==========================================

	if current_call_id == "call_2":

		Global.remote_available = true

		print("REMOTE NOW AVAILABLE")


	# ==========================================
	# CALL 4
	# ==========================================

	if current_call_id == "call_4":

		Global.can_fix_radio = true

		print("RADIO CAN NOW BE FIXED")


	# ==========================================
	# CALL 5
	# ==========================================

	if current_call_id == "call_5":

		Global.unlock_buttons()


	# ==========================================
	# CALL 7
	# ==========================================

	if current_call_id == "call_7":

		Global.call_7_finished_now()

		print("CALL 7 FINISHED - ENDINGS CAN NOW TRIGGER")


	# ==========================================
	# FINISH CALL
	# ==========================================

	Global.finish_call()

	current_call_id = ""


	# ==========================================
	# NEXT CALL
	# ==========================================

	if not Global.pending_calls.is_empty():

		_on_call_available()


# ==========================================
# DIALOGUE
# ==========================================

func play_dialogue(lines: Array, text_color := Color.WHITE):

	for line in lines:


		# ==========================================
		# WAIT FOR BEDROOM DOOR
		# ==========================================

		if line == "WAIT_FOR_DOOR":

			if not Global.bedroom_door_is_locked:

				await Global.bedroom_door_locked

			continue


		# ==========================================
		# WAIT FOR BEDROOM LIGHT
		# ==========================================

		if line == "WAIT_FOR_LIGHT":

			while Global.bedroom_light:

				await get_tree().process_frame

			continue


		# ==========================================
		# SHOW SPEECH
		# ==========================================

		var player = get_tree().get_first_node_in_group("player")


		if player != null:

			player.show_speech(
				line,
				3.0,
				text_color
			)


		await get_tree().create_timer(3.0).timeout


	# ==========================================
	# RESET SPEECH COLOR
	# ==========================================

	var player = get_tree().get_first_node_in_group("player")


	if player != null:

		player.speech.modulate = Color.WHITE
