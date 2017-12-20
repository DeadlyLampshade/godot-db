tool
extends VBoxContainer

var name = "" setget set_name

func set_name(value):
	$Label.text = "%s: " % value
	name = value

func prepare(dict):
	return

func clean():
	return $TextEdit.text

func unclean(data):
	if data != null:
		$TextEdit.text = str(data)