tool
extends VBoxContainer

const enums = preload("../../Enums.gd")

const STRING_CONTROL = preload("../Controls/StringControl.tscn")
const STRING_MULTILINE_CONTROL = preload("../Controls/StringMultilineControl.tscn")
const NUMBER_CONTROL = preload("../Controls/NumberControl.tscn")
const COLOR_CONTROL = preload("../Controls/ColorControl.tscn")
const BOOLEAN_CONTROL = preload("../Controls/CheckButtonControl.tscn")
const INVALID_CONTROL = preload("../Controls/InvalidControl.tscn")

var control_list = []

func populate_control_list(header, item_values):
	for i in header:
		var values
		if item_values.has(i.name):
			values = item_values[i.name]
		add_control(i.name, i.type, values)
	pass

func add_control(header_name, header_type, item_values):
	var control
	if header_type.type == enums.DATA_TYPE.STRING: control = STRING_CONTROL.instance()
	elif header_type.type == enums.DATA_TYPE.STRING_MULTILINE: control = STRING_MULTILINE_CONTROL.instance()
	elif header_type.type == enums.DATA_TYPE.BOOLEAN: control = BOOLEAN_CONTROL.instance()
	elif header_type.type == enums.DATA_TYPE.NUMBER: control = NUMBER_CONTROL.instance()
	elif header_type.type == enums.DATA_TYPE.COLOR: control = COLOR_CONTROL.instance()
	else: control = INVALID_CONTROL.instance()
	add_child(control)
	control.set_name(header_name)
	control.unclean(item_values)
	control_list.append(control)

func clear_control_list():
	for i in control_list:
		i.queue_free()
	control_list = []

func clean():
	var dictionary = {}
	for i in control_list:
		dictionary[i.name] = i.clean()
	return dictionary