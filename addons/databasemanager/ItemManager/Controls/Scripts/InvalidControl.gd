tool
extends Label

var name = "" setget set_name

func set_name(value):
	name = value
	text = "Invalid Control Type: %s" % name

func clean():
	return ""

func unclean(variant):
	pass