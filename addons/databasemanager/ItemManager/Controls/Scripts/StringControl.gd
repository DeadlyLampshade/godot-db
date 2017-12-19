tool
extends HBoxContainer

var name = "" setget set_name

func set_name(value):
	name = value
	$Label.text = "%s: " % name

func clean():
	return $LineEdit.text

func unclean(variant):
	if variant != null:
		$LineEdit.text = variant