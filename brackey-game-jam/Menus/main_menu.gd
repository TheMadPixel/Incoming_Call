extends Control

@export_file("*.tscn") var first_level: String
@onready var control: Control = $Control
@onready var endings: Control = $Endings2


func _on_play_pressed() -> void:
	print("PLAY PRESSED")
	print("First level: ", first_level)

	if first_level == "":
		print("NO FIRST LEVEL ASSIGNED")
		return

	Global.starting_game = true

	await Transition.fade_to_black()

	print("CHANGING SCENE")

	get_tree().change_scene_to_file(first_level)


func _on_quit_pressed() -> void:
	get_tree().quit()


func _ready():
	Transition.fade_from_black()
	endings.visible = false
	control.visible = false
func _on_options_pressed() -> void:
	control.visible = true


func _on_endings_pressed() -> void:
	endings.visible = true
