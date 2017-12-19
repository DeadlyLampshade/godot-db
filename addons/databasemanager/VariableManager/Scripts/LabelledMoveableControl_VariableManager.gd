tool
extends "MoveableControl_VariableManager.gd"

onready var label = $TopBar/LineEdit setget set_label, get_label

func set_label(value):
	label.text = value

func get_label(value):
	return label.text

func _clean():
	var dict = ._clean()
	dict.name = label.text
	return dict

func _unclean(variant):
	._unclean(variant)
	label.text = variant.name