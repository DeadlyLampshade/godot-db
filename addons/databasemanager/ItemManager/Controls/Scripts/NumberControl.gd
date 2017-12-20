tool
extends HBoxContainer

var name = "" setget set_name

func set_name(value):
	name = value
	$Label.text = "%s: " % name

func prepare(dict):
	return

func clean():
	if $LineEdit.text.is_valid_integer():
		return $LineEdit.text.to_int()
	elif $LineEdit.text.is_valid_float():
		return $LineEdit.text.to_float()
	else:
		return 0

func unclean(variant):
	if variant != null:
		$LineEdit.text = str(variant)