tool
extends VBoxContainer

var name = "" setget set_name

func set_name(value):
	name = value
	$TopRow/HBoxContainer/Label.text = "%s" % name

func prepare(dict, values):
	$ItemManager/ItemManager.columns = dict.arguments.row_count
	$ItemManager/ItemManager.populate_control_list(dict.arguments.contents, values)
	$ItemManager.hide()
	$TopRow/HBoxContainer/OpenButton.text = "Close" if $ItemManager.visible else "Open"

func clean():
	return $ItemManager/ItemManager.clean()

func unclean(variant):
	pass


func open_button_pressed():
	$ItemManager.visible = !$ItemManager.visible
	$TopRow/HBoxContainer/OpenButton.text = "Close" if $ItemManager.visible else "Open"
	pass # replace with function body
