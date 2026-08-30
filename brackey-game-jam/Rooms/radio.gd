extends Button

@export var interaction_range := 150.0

@export_multiline var broken_inspect_text := "It's broken."
@export_multiline var fixed_inspect_text := "It's working."

@onready var broken_sprite: Sprite2D = $BrokenSprite
@onready var fixed_sprite: Sprite2D = $FixedSprite
@onready var speech: Label = $Speech


var fixing := false



func _ready():
	broken_sprite.visible = true
	fixed_sprite.visible = false
	speech.visible = false

	gui_input.connect(_on_gui_input)


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

		if event.button_index == MOUSE_BUTTON_LEFT:

			if not Global.radio_fixed and Global.can_fix_radio and not fixing:
				fix_radio()

		elif event.button_index == MOUSE_BUTTON_RIGHT:

			if Global.radio_fixed:
				player.inspect_object(fixed_inspect_text)
			else:
				player.inspect_object(broken_inspect_text)


func fix_radio():

	fixing = true

	Global.radio_fixed = true

	broken_sprite.visible = false
	fixed_sprite.visible = true

	if Global.has_manual:
		await play_radio_dialogue()

	fixing = false


func play_radio_dialogue():

	var dialogue = [
		{
			"text": "*You fix the radio and tune it to the frequency you found*",
			"color": Color.WHITE
		},
		{
			"text": "<fzzt>",
			"color": Color.WHITE
		},
		{
			"text": "...power...",
			"color": Color("#0097ed")
		},
		{
			"text": "<fzzt>",
			"color": Color.WHITE
		},
		{
			"text": "..cameras...",
			"color": Color("#c10021")
		},
		{
			"text": "<fzzt>",
			"color": Color.WHITE
		},
		{
			"text": "...ask him...",
			"color": Color("#0097ed")
		},
		{
			"text": "<fzzt>",
			"color": Color.WHITE
		}
	]

	speech.visible = true

	for line in dialogue:

		speech.text = line["text"]
		speech.modulate = line["color"]

		await get_tree().create_timer(3.0).timeout

	speech.text = ""
	speech.modulate = Color.WHITE
	speech.visible = false
