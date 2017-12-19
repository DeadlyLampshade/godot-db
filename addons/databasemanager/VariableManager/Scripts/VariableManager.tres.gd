tool
extends VBoxContainer

const MOVEABLE_CONTROL = preload("../MoveableControl_VariableManager.tscn")
const LABELLED_MOVEABLE_CONTROL = preload("../LabelledMoveableControl_VariableManager.tscn")

onready var controls = $ControlContainer

func _ready():
	$AddOption.connect("pressed", self, "add_option")

func add_option(values = {"name": "New", "type": {"type": 0, "reference": ""}}):
	var new_control = LABELLED_MOVEABLE_CONTROL.instance()
	controls.add_child(new_control)
	new_control._unclean(values)

func clean():
	var array = []
	for i in controls.get_children():
		array.append(i._clean())
	return array

func unclean(variant=[{}]):
	for i in variant:
		add_option(i)
	pass

func erase_controls():
	for i in controls.get_children():
		i.queue_free()