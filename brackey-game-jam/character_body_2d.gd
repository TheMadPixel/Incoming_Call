extends CharacterBody2D

@export var speed := 300.0
@export var overhead_tilemap: TileMapLayer

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var speech: Label = $Speech

var speech_tween: Tween


func _ready():
	speech.visible = false

	await get_tree().process_frame

	var doors = get_tree().get_nodes_in_group("doors")

	if Global.spawn_point != "":
		for door in doors:
			if door.door_id == Global.spawn_point:
				global_position = door.door_position.global_position
				break

		Global.spawn_point = ""

	if Global.starting_game:
		Global.starting_game = false
		await Transition.fade_from_black_slow()
	else:
		Transition.fade_from_black()


func _process(_delta):
	if overhead_tilemap:
		var material := overhead_tilemap.material as ShaderMaterial

		if material:
			var screen_position := get_viewport().get_canvas_transform() * global_position
			var screen_size := get_viewport_rect().size

			material.set_shader_parameter(
				"player_screen_position",
				screen_position
			)

			material.set_shader_parameter(
				"screen_size",
				screen_size
			)


func _physics_process(_delta):
	var direction := Input.get_vector(
		"MoveLeft",
		"MoveRight",
		"MoveUp",
		"MoveDown"
	)

	velocity = direction * speed
	move_and_slide()

	if direction.x < 0:
		sprite.flip_h = true
	elif direction.x > 0:
		sprite.flip_h = false

	if direction != Vector2.ZERO:
		sprite.play_backwards("walking")
	else:
		sprite.play("default")


func show_speech(text: String, duration := 3.0, text_color := Color.WHITE):
	speech.modulate = text_color
	speech.text = text
	speech.visible = true

	if speech_tween:
		speech_tween.kill()

	speech_tween = create_tween()
	speech_tween.tween_interval(duration)
	speech_tween.tween_callback(hide_speech)


func hide_speech():
	speech.visible = false


func inspect_object(text: String):
	show_speech(text, 3.0)
