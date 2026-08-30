extends Node

signal has_phone_changed(value)
signal call_available
signal bedroom_door_locked
signal scene_changed
signal buttons_unlocked

@onready var door_sound: AudioStreamPlayer = $DragonStudioOpenAndClosedDoor405452
@onready var knocking: AudioStreamPlayer = $knocking
@onready var footsteps: AudioStreamPlayer = $footsteps
@onready var gunshot: AudioStreamPlayer = $gunshot

@onready var ending_sound_1: AudioStreamPlayer = $EndingSound1
@onready var ending_sound_2: AudioStreamPlayer = $EndingSound2

var maya_ending
var daniel_ending
var trust_no_one_ending

var maya_ending_unlocked := false
var daniel_ending_unlocked := false
var trust_no_one_ending_unlocked := false

var picture_frame_removed := false

var can_use_buttons := false
var special_button_selected := false
var special_button_index := -1
var special_button_found := false

var bedroom_light := true
var bedroom_door_is_locked := false

var has_manual := false
var manual_available := true

var can_fix_radio := false
var radio_fixed := false

var remote_available := false
var has_remote := false

var call_7_finished := false

var ending_active := false
var doors_locked_for_ending := false

var spawn_point := ""
var starting_game := true
var game_started := false

var previous_scene: String = ""
var current_scene: String = ""

var has_phone := false:
	set(value):
		if has_phone == value:
			return

		has_phone = value
		has_phone_changed.emit(value)

var game_seconds := 1800.0
var time_speed := 45.0

var pending_calls: Array[String] = []

var calls = {

	"call_1": {
		"time": 1800.0,
		"caller": "Daniel",
		"text": [
			"Hey, you're finally awake.",
			"Listen, something went wrong.",
			"Don't panic.",
			"Stay in your bedroom for now.",
			"Lock the door.",
			"WAIT_FOR_DOOR",
			"Turn off the light.",
			"WAIT_FOR_LIGHT",
			"Ok, stay put and dont make any noise",
			"I'll call you later."
		],
		"color": Color("c10021ff"),
		"triggered": false
	},

	"call_2": {
		"time": 5400.0,
		"caller": "Maya",
		"text": [
			"Daniel called you, didn't he?",
			"Don't trust him, he's lying.",
			"You need to hide in the living room.",
			"Be careful, try to turn off things that make noise."
		],
		"color": Color("0097edff"),
		"triggered": false
	},

	"call_3": {
		"time": 7200.0,
		"caller": "Daniel",
		"text": [
			"Did Maya send you to the living room?",
			"There's something you need to understand.",
			"She doesn't know what's happening.",
			"Whatever she told you to look for, don't.",
			"And don't touch the T-"
		],
		"color": Color("c10021ff"),
		"triggered": false
	},

	"call_4": {
		"time": 9000.0,
		"caller": "Maya",
		"text": [
			"Are you alright?",
			"Ok, I need you to go to the kitchen.",
			"There's a broken old radio in the kitchen.",
			"Maybe there's a manual around",
			"See if you can fix it."
		],
		"color": Color("0097edff"),
		"triggered": false
	},

	"call_5": {
		"time": 10800.0,
		"caller": "Daniel",
		"text": [
			"Hey. It's me again.",
			"Have the lights been fli- <fzzt>",
			"Yeah. You- <fzzt> -fix them.",
			"Try to find a spare fuse. It's- <fzzt> -the power box."
		],
		"color": Color("c10021ff"),
		"triggered": false
	},

	"call_6": {
		"time": 12600.0,
		"caller": "Maya",
		"text": [
			"Ok, I need you to listen carefully.",
			"I need you to hide in the living room.",
			"Don't open any doors or make any sound.",
			"Until 4 am.",
			"No matter what.",
			"And don't trust Daniel."
		],
		"color": Color("0097edff"),
		"triggered": false
	},

	"call_7": {
		"time": 12700.0,
		"caller": "Daniel",
		"text": [
			"Don't listen... <fzzt> ... Maya!",
			"She's.. <fzzt> ...to you!",
			"You need to... <fzzt> ...in the bedroom.",
			"Lock the... <fzzt> ...the lights.",
			"Don't... <fzzt> ...matter what.",
			"I'll... <fzzt> ...when it's safe."
		],
		"color": Color("c10021ff"),
		"triggered": false
	}
}


func _ready():
	get_tree().scene_changed.connect(_on_scene_changed)


func _process(delta):

	var scene = get_tree().current_scene

	if scene == null:
		return

	if scene.name == "MainMenu":
		return

	if ending_active:
		return

	game_seconds += delta * time_speed

	if game_seconds >= 86400.0:
		game_seconds = fmod(game_seconds, 86400.0)

	for call_id in calls:

		var call_data = calls[call_id]

		if game_seconds >= call_data["time"] and not call_data["triggered"]:

			call_data["triggered"] = true

			pending_calls.append(call_id)

			call_available.emit()

	if game_seconds >= 14400.0:

		if knocking and not knocking.playing:

			knocking.play()

	check_endings()


func _on_scene_changed():

	var new_scene = get_tree().current_scene

	if new_scene == null:
		return

	var new_scene_path: String = new_scene.scene_file_path

	previous_scene = current_scene
	current_scene = new_scene_path

	if entered_hallway_from_room() or left_hallway_to_room():

		if door_sound:
			door_sound.play()

	scene_changed.emit()


func entered_hallway_from_room() -> bool:

	if current_scene != "res://Rooms/hallway.tscn":
		return false

	return previous_scene == "res://Rooms/bedroom.tscn" \
		or previous_scene == "res://Rooms/kitchen.tscn" \
		or previous_scene == "res://Rooms/livingroom.tscn"


func left_hallway_to_room() -> bool:

	if previous_scene != "res://Rooms/hallway.tscn":
		return false

	return current_scene == "res://Rooms/bedroom.tscn" \
		or current_scene == "res://Rooms/kitchen.tscn" \
		or current_scene == "res://Rooms/livingroom.tscn"


func get_next_call() -> String:

	if pending_calls.is_empty():
		return ""

	return pending_calls[0]


func finish_call():

	if not pending_calls.is_empty():
		pending_calls.pop_front()


func call_7_finished_now():

	call_7_finished = true


func unlock_buttons():

	can_use_buttons = true

	buttons_unlocked.emit()


func check_endings():

	if ending_active:
		return

	if not call_7_finished:
		return

	if game_seconds < 14400.0:
		return

	var scene = get_tree().current_scene

	if scene == null:
		return

	if scene.name == "Bedroom":

		if not bedroom_light and bedroom_door_is_locked:

			trigger_ending("daniel_ending")

			return

	if scene.name == "LivingRoom":

		trigger_ending("maya_ending")

		return

	if scene.name == "Kitchen":

		trigger_ending("trust_no_one_ending")

		return


func trigger_ending(ending_id: String):

	if ending_active:
		return

	ending_active = true
	doors_locked_for_ending = true

	match ending_id:

		"daniel_ending":

			daniel_ending_unlocked = true

			await daniel_ending_sequence()

		"maya_ending":

			maya_ending_unlocked = true

			await maya_ending_sequence()

		"trust_no_one_ending":

			trust_no_one_ending_unlocked = true

			await trust_no_one_ending_sequence()


func daniel_ending_sequence():

	if knocking:

		knocking.play()

		await wait_for_audio(knocking)

	if door_sound:

		door_sound.play()

		await wait_for_audio(door_sound)

	if footsteps:

		footsteps.play()

		await wait_for_audio(footsteps)

	await get_tree().create_timer(1.0).timeout

	Transition.fade_to_black()

	await get_tree().create_timer(1.0).timeout

	if gunshot:

		gunshot.play()

		await wait_for_audio(gunshot)

	if door_sound:

		door_sound.play()

		await wait_for_audio(door_sound)

	if footsteps:

		footsteps.play()

		await get_tree().create_timer(3.0).timeout

		footsteps.stop()

	if gunshot:

		gunshot.play()

		await wait_for_audio(gunshot)

	return_to_menu()


func maya_ending_sequence():

	if knocking:

		knocking.play()

		await wait_for_audio(knocking)

	if door_sound:

		door_sound.play()

		await wait_for_audio(door_sound)

	if footsteps:

		footsteps.play()

		await wait_for_audio(footsteps)

	Transition.fade_to_black()

	await get_tree().create_timer(1.0).timeout

	if door_sound:

		door_sound.play()

		await wait_for_audio(door_sound)

	if gunshot:

		gunshot.play()

		await wait_for_audio(gunshot)

	return_to_menu()


func trust_no_one_ending_sequence():

	if knocking:

		knocking.play()

		await wait_for_audio(knocking)

	if door_sound:

		door_sound.play()

		await wait_for_audio(door_sound)

	if footsteps:

		footsteps.play()

		await wait_for_audio(footsteps)

	if door_sound:

		door_sound.play()

		await wait_for_audio(door_sound)

	if footsteps:

		footsteps.play()

		await wait_for_audio(footsteps)

	if door_sound:

		door_sound.play()

		await wait_for_audio(door_sound)

	Transition.fade_to_black()

	await get_tree().create_timer(1.0).timeout

	return_to_menu()


func wait_for_audio(player: AudioStreamPlayer):

	if player == null:
		return

	if player.stream == null:
		return

	var length := player.stream.get_length()

	if length > 0.0:

		await get_tree().create_timer(length).timeout

	else:

		await get_tree().create_timer(1.0).timeout


func return_to_menu():

	if knocking and knocking.playing:
		knocking.stop()

	if footsteps and footsteps.playing:
		footsteps.stop()

	if door_sound and door_sound.playing:
		door_sound.stop()

	if gunshot and gunshot.playing:
		gunshot.stop()

	has_phone = false

	picture_frame_removed = false

	can_use_buttons = false
	special_button_selected = false
	special_button_index = -1
	special_button_found = false

	bedroom_light = true
	bedroom_door_is_locked = false

	has_manual = false
	manual_available = true

	can_fix_radio = false
	radio_fixed = false

	remote_available = false
	has_remote = false

	call_7_finished = false

	ending_active = false
	doors_locked_for_ending = false

	spawn_point = ""
	starting_game = true
	game_started = false

	previous_scene = ""
	current_scene = ""

	game_seconds = 1800.0

	pending_calls.clear()

	for call_id in calls:
		calls[call_id]["triggered"] = false

	await get_tree().create_timer(0.2).timeout

	get_tree().change_scene_to_file(
		"res://Menus/MainMenu.tscn"
	)


func get_time_string() -> String:

	var total_seconds := int(game_seconds)

	var hours := total_seconds / 3600

	var minutes := (total_seconds % 3600) / 60

	return "%02d:%02d" % [hours, minutes]
