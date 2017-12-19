tool
extends HBoxContainer

var name = "" setget set_name

func set_name(value):
	$Label.text = "%s: " % value
	name = value

func clean():
	return $CheckButton.pressed

func unclean(data):
	if data != null:
		$CheckButton.pressed = data