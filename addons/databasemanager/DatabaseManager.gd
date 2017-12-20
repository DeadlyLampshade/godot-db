tool
extends PanelContainer

signal reference_id_updated

const enums = preload("Enums.gd")
const JSON_WRITER = preload("NewJSONWriter.gd")

onready var tree_container = $BoxContainer/MainContainer/TreeContainer
onready var tree = tree_container.get_node("Tree")
onready var add_item_button = tree_container.get_node("AddItem")
onready var add_datatype_button = tree_container.get_node("AddDataType")

onready var id_edit = $BoxContainer/MainContainer/DataContainer/HBoxContainer/LineEdit

onready var data_container = $BoxContainer/MainContainer/DataContainer
onready var variableManager = data_container.get_node("ScrollContainer/VariableManager")
onready var itemManager = data_container.get_node("ScrollContainer/ItemManager")

onready var root = create_root()
var data_type = []
var items = []

var dontchange = false

var current_selection

func serialize_data():
	if current_selection != null:
		if selected_item_is_item(current_selection):
			current_selection.set_metadata(0, itemManager.clean())
		if selected_item_is_datatype(current_selection):
			current_selection.set_metadata(0, variableManager.clean())
	var child = root.get_children()
	while(child != null):
		var dictionary = {
			"name": child.get_text(0), 
			"contents": {
				"header": child.get_metadata(0), 
				"contents": get_all_children(child)
			}
		}
		save_file(dictionary)
		child = child.get_next()
	disable_save_and_load_temp()

func get_all_children(parent):
	var instances = parent.get_children()
	var dict = {}
	while(instances != null):
		dict[instances.get_text(0)] = instances.get_metadata(0)
		instances = instances.get_next()
	return dict

func save_file(dictionary):
	var file = File.new()
	var err = file.open("res://data/%s.json" % dictionary.name, File.WRITE)
	if err == OK:
		var make_string = JSON_WRITER.write_dictionary(dictionary.contents)
		file.store_string(make_string)
	file.close()
	pass

func save_data():
	var dir = Directory.new()
	var file = File.new()
	var error = OK
	
	if !dir.dir_exists("res://data"):
		error = dir.make_dir("res://data")
		assert(error == OK)
	
	serialize_data()

func load_data():
	var dir = Directory.new()
	var file = File.new()
	var err = OK
	
	if !dir.dir_exists("res://data"):
		return
	
	var dictionary = {}
	
	err = dir.open("res://data")
	if err == OK:
		dir.list_dir_begin(false)
		var child = dir.get_next()
		while(!child.empty()):
			err = file.open("res://data/%s" % child, File.READ)
			if err == OK:
				var file_contents = JSON.parse(file.get_as_text())
				if file_contents.error == OK: dictionary[child.get_basename()] = file_contents.result
			file.close()
			child = dir.get_next()
		unserialize_data(dictionary)

func unserialize_data(data):
	var keys = data.keys()
	var values = data.values()
	
	for i in range(data.size()):
		var dt = create_data_type(keys[i])
		
		if values[i].has("header"):
			dt.set_metadata(0, values[i].header)
		else:
			dt.set_metadata(0, [])
		
		var keys_internal = values[i].contents.keys()
		var values_internal = values[i].contents.values()
		for y in range(values[i].contents.size()):
			var item = create_item(keys_internal[y], data_type.find(dt))
			item.set_metadata(0, values_internal[y])
	pass

func _ready():
	get_tree().set_meta("database_manager", self)
	id_edit.connect("text_entered", self, "change_id")
	tree.connect("item_selected", self, "select_item")
	add_item_button.connect("pressed", self, "create_item_for_selection")
	add_datatype_button.connect("pressed", self, "create_data_type_and_select")
	tree.set_hide_root(true)
	load_data()
	pass

func _unhandled_input(event):
	if tree.has_focus():
		if event is InputEventKey:
			if event.scancode == KEY_DELETE and event.pressed and !event.echo:
				if current_selection != null:
					current_selection.free()
					current_selection = null
					tree.accept_event()

func create_item_for_selection():
	if current_selection == null: return
	
	if current_selection in data_type: 
		create_item("New Item", data_type.find(current_selection)).select(0)
	elif current_selection.get_parent() in data_type: 
		var parent = current_selection.get_parent()
		create_item("New Item", data_type.find(parent)).select(0)

func selected_item_is_datatype(variant):
	return variant in data_type

func selected_item_is_item(variant):
	return variant.get_parent() in data_type

func select_item():
	
	if current_selection != null:
		
		if selected_item_is_datatype(current_selection):
			current_selection.set_metadata(0, variableManager.clean())
			variableManager.erase_controls()
		
		if selected_item_is_item(current_selection):
			current_selection.set_metadata(0, itemManager.clean())
			itemManager.clear_control_list()
	
	current_selection = tree.get_selected()
	id_edit.text = current_selection.get_text(0)
	
	if selected_item_is_datatype(current_selection):
		variableManager.show()
		if current_selection.get_metadata(0) != null:
			variableManager.unclean(current_selection.get_metadata(0))
	else:
		variableManager.hide()
	
	if selected_item_is_item(current_selection):
		itemManager.show()
		var parent = current_selection.get_parent()
		if parent.get_metadata(0) != null:
			itemManager.populate_control_list(parent.get_metadata(0), current_selection.get_metadata(0))
	else:
		itemManager.hide()

func change_id(text):
	if current_selection != null and !dontchange: 
		current_selection.set_text(0, text)
		emit_signal("reference_id_updated")

func create_root():
	var root = tree.create_item()
	return root

func create_data_type_and_select():
	create_data_type().select(0)

func create_data_type(name = "New"):
	var dt = tree.create_item(root)
	dt.set_text(0, name)
	data_type.append(dt)
	items.append([])
	return dt

func create_item(name, dt):
	var item = tree.create_item(data_type[dt])
	item.set_text(0, name)
	item.set_metadata(0, {})
	items[dt].append(item)
	return item

func disable_save_and_load_temp():
	$BoxContainer/MenuOptions/SaveButton.disabled = true
	$BoxContainer/MenuOptions/ReloadButton.disabled = true
	yield(get_tree().create_timer(2), "timeout")
	$BoxContainer/MenuOptions/SaveButton.disabled = false
	$BoxContainer/MenuOptions/ReloadButton.disabled = false

func reload_database():
	tree.clear()
	data_type = []
	items = []
	current_selection = null
	root = create_root()
	variableManager.erase_controls()
	itemManager.clear_control_list()
	load_data()
	disable_save_and_load_temp()
	pass # replace with function body
