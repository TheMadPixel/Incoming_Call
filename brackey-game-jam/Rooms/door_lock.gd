extends Button

@export var door: Button

@onready var freesound_community_lock_the_door_46014: AudioStreamPlayer = $FreesoundCommunityLockTheDoor46014


func _on_pressed():
	if door == null:
		return

	door.toggle_lock()

	if not freesound_community_lock_the_door_46014.playing:
		freesound_community_lock_the_door_46014.play()
