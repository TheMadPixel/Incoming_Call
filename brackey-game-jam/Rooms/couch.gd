extends Node2D

@onready var sort_point: Marker2D = $SortPoint

var player: Node2D


func _ready():
	player = get_tree().get_first_node_in_group("player")


func _process(_delta):
	if player == null:
		return

	if player.global_position.y < sort_point.global_position.y:
		z_index = player.z_index + 1
	else:
		z_index = player.z_index - 1
