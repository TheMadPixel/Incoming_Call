extends Control
@onready var control: Control = $"."

@onready var maya_label: Label = $Worldcellphone6/maya
@onready var daniel_label: Label = $Worldcellphone5/daniel
@onready var trust_no_one_label: Label = $Worldcellphone7/trust_no_one


func _ready():

	if Global.maya_ending_unlocked:
		maya_label.text = "Trusted Maya"
	else:
		maya_label.text = "Unknown"


	if Global.daniel_ending_unlocked:
		daniel_label.text = "Trusted Daniel"
	else:
		daniel_label.text = "Unknown"


	if Global.trust_no_one_ending_unlocked:
		trust_no_one_label.text = "Trusted No One"
	else:
		trust_no_one_label.text = "Unknown"


func _on_return_pressed() -> void:
	control.visible = false
