tool
extends HBoxContainer

var name = "" setget set_name

func set_name(value):
	$Label.text = "%s: " % value
	name = value

func prepare(dict):
	return

func clean():
	return $CheckButton.pressed

func unclean(data):
	if data != null and typeof(data) == TYPE_BOOL:
		$CheckButton.pressed = data