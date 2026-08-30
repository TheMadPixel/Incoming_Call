extends Control

@onready var control: Control = $"."

var game_paused := false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	control.visible = false


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE:

			if control.visible:
				close_menu()
			else:
				open_menu()


func open_menu() -> void:
	control.visible = true
	game_paused = true
	get_tree().paused = true


func close_menu() -> void:
	control.visible = false
	game_paused = false
	get_tree().paused = false


func _on_return_pressed() -> void:
	close_menu()


func _on_menu_pressed() -> void:
	get_tree().paused = false
	game_paused = false
	get_tree().change_scene_to_file("res://Menus/MainMenu.tscn")
