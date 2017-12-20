tool
extends Reference

static func create_tabs(tabs):
	var tab_add = ""
	for i in range(tabs):
		tab_add += "\t"
	return tab_add

static func write_value(value, tabs=0):
	var string = ""
	if typeof(value) in [TYPE_INT, TYPE_REAL]:
		string += "%s" % value
	elif typeof(value) in [TYPE_BOOL, TYPE_NIL]:
		string += "%s" % str(value).to_lower()
	elif typeof(value) == TYPE_DICTIONARY:
		string += write_dictionary(value, tabs, false)
	elif typeof(value) == TYPE_ARRAY:
		string += write_array(value, tabs, false)
	else:
		string += "\"%s\"" % str(value).c_escape()
	return string

static func write_array(variant, tabs=0, start_tabbed = false):
	var string = "[\n"
	var tab_add = create_tabs(tabs)
	if start_tabbed:
		string = "\n" + tab_add + string
	
	var additional_tabs = tabs + 1
	
	for i in range(variant.size()):
		if i != 0: string += ",\n"
		string += "%s\t%s" % [tab_add, write_value(variant[i], additional_tabs)]
	
	string += "\n%s]" % tab_add
	return string

static func write_dictionary(variant, tabs=0, start_tabbed = false):
	var tab_add = create_tabs(tabs)
	var string = "{\n"
	if start_tabbed:
		string = "\n" + tab_add + string
	
	var additional_tabs = tabs + 1
	
	var key_names = variant.keys()
	var key_values = variant.values()
	
	for i in range(variant.size()):
		if i != 0: string += ",\n"
		string += "%s\t\"%s\": %s" % [tab_add, key_names[i], write_value(key_values[i], additional_tabs)]
		
	string += "\n%s}" % tab_add
	
	return string