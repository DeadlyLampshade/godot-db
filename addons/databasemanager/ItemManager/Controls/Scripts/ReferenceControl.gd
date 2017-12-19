tool
extends HBoxContainer

var name = "" setget set_name

func set_name(value):
	name = value
	$Label.text = "%s: " % value

func prepare(dict):
	var object = null
	for i in get_tree().get_meta("database_manager").data_type:
		if i.get_text(0) == dict.reference:
			object = i
			break
	
	$OptionButton.add_item("None")
	$OptionButton.set_item_metadata(0, null)
	
	if object != null:
		var child = object.get_children()
		while(child != null):
			$OptionButton.add_item(child.get_text(0))
			$OptionButton.set_item_metadata($OptionButton.get_item_count()-1, child.get_text(0))
			child = child.get_next()

func clean():
	return $OptionButton.get_item_metadata($OptionButton.selected)

func unclean(data):
	if data != null:
		$OptionButton.select(data)
	else:
		$OptionButton.select(0)