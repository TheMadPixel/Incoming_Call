extends Button

@export var interaction_range := 150.0
@export_multiline var inspect_text := "Dang it, where did i put the remote again?"

@onready var tv_off: Sprite2D = $Tvoff
@onready var tv_on: Sprite2D = $"../Tv"
@onready var tv_text: Label = $TVText

var dialogue_running := false
var over := false


func _ready():
	tv_off.visible = true
	tv_on.visible = false
	tv_text.visible = false

	print("TV LOADED")
	print("Has remote: ", Global.has_remote)

	gui_input.connect(_on_gui_input)


func _on_gui_input(event: InputEvent):

	if event is InputEventMouseButton and event.pressed:

		print("TV CLICKED")
		print("Button: ", event.button_index)

		var player = get_tree().get_first_node_in_group("player")

		if player == null:
			print("NO PLAYER FOUND")
			return

		var distance := global_position.distance_to(player.global_position)

		print("Distance: ", distance)
		print("Has remote: ", Global.has_remote)
		print("Dialogue running: ", dialogue_running)
		print("Already used: ", over)

		if distance > interaction_range:
			print("TOO FAR")
			return

		if event.button_index == MOUSE_BUTTON_LEFT:

			if not Global.has_remote:
				print("NO REMOTE")
				return

			if dialogue_running:
				print("DIALOGUE ALREADY RUNNING")
				return

			if over:
				print("TV ALREADY USED")
				return

			print("STARTING TV")
			turn_on()

		elif event.button_index == MOUSE_BUTTON_RIGHT:

			player.inspect_object(inspect_text)


func turn_on():

	over = true
	dialogue_running = true

	print("TURNING TV ON")

	tv_off.visible = false
	tv_on.visible = true
	tv_text.visible = true

	await play_tv_dialogue()

	print("TV DIALOGUE FINISHED")

	tv_text.visible = false
	tv_on.visible = false
	tv_off.visible = true

	dialogue_running = false


func play_tv_dialogue():

	var dialogue = [
		{
			"text": "<fzzt>.",
			"color": Color.WHITE
		},
		{
			"text": "...they can't know...",
			"color": Color("#c10021")
		},
		{
			"text": "<fzzt>.",
			"color": Color.WHITE
		},
		{
			"text": "...put it there?...",
			"color": Color("#0097ed")
		},
		{
			"text": "<fzzt>.",
			"color": Color.WHITE
		},
		{
			"text": "...get it out of there...",
			"color": Color("#c10021")
		},
		{
			"text": "<fzzt>.",
			"color": Color.WHITE
		},
	]

	for line in dialogue:

		tv_text.text = line["text"]
		tv_text.modulate = line["color"]

		print("TV LINE: ", line["text"])

		await get_tree().create_timer(3.0).timeout

	tv_text.modulate = Color.WHITE
	
	Global.picture_frame_removed = true
