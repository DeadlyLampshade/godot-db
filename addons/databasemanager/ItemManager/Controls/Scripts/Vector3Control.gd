tool
extends VBoxContainer

var name = "" setget set_name

func set_name(value):
	name = value
	$Label.text = "%s: " % name

func prepare(dict):
	return

func get_number(value):
	if value.is_valid_integer():
		return value.to_int()
	elif value.is_valid_float():
		return value.to_float()
	else:
		return 0

func clean():
	return { "x": get_number($HBoxContainer/LineEdit), "y": get_number($HBoxContainer/LineEdit2), "z": get_number($HBoxContainer/LineEdit3)}

func unclean(variant):
	if variant != null:
		$HBoxContainer/LineEdit.text = str(variant.x)
		$HBoxContainer/LineEdit2.text = str(variant.y)
		$HBoxContainer/LineEdit3.text = str(variant.z)
