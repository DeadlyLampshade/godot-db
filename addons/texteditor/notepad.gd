tool
extends PanelContainer

var EDITORPLUGIN

onready var title_edit = $VBoxContainer/HBoxContainer/MainContainer/LineEdit
onready var text_edit = $VBoxContainer/HBoxContainer/MainContainer/TextEdit
onready var note_list = $VBoxContainer/HBoxContainer/ItemList

var notes = []
var do_not_change = false
var currently_selected = -1

func _ready():
	pass

func _unhandled_input(event):
	if note_list.has_focus():
		if event is InputEventKey:
			if (event.scancode == KEY_DELETE or event.scancode == KEY_BACKSPACE) and event.pressed:
				if !notes.empty():
					delete_item()
					currently_selected = max(currently_selected - 1, 0)
					note_list.select(currently_selected)
					select_item(currently_selected)
					note_list.accept_event()

func delete_item():
	
	var file_system = Directory.new()
	
	var current_item = notes[currently_selected]
	
	var file_path = "res://"
	if current_item.has("old_title"):
		file_path += "%s/%s.txt" % ["notes", current_item.old_title]
	else:
		file_path += "%s/%s.txt" % ["notes", current_item.title]
	
	print(file_path)
	
	if file_system.file_exists(file_path):
		var error = file_system.remove(file_path)
		print(error)
	
	notes.remove(currently_selected)
	
	refresh()

func create_new():
	note_list.add_item(" ")
	note_list.select(note_list.get_item_count()-1)
	var dict = {"title": "New", "contents": "", "has_changed": false}
	notes.append(dict)
	select_item(note_list.get_item_count()-1)

func select_item(integer):
	currently_selected = integer
	if notes.empty():
		return
	var note = notes[integer]
	do_not_change = true
	text_edit.readonly = false
	text_edit.text = note.contents
	title_edit.editable = true
	title_edit.text = note.title
	do_not_change = false

func save_changes():
	if do_not_change: return
	notes[currently_selected].title = title_edit.text
	notes[currently_selected].contents = text_edit.text
	notes[currently_selected].has_changed = true
	note_list.set_item_text(currently_selected, title_edit.text)

func save_title( text ):
	save_changes()
	pass

func save_data():
	var title_list = []
	var file_system = Directory.new()
	var file = File.new()
	
	if !file_system.dir_exists("res://notes"):
		file_system.make_dir("res://notes")
	
	for i in notes:
		if i.has_changed:
			i.has_changed = false
			if i.has("old_title"):
				file_system.remove("%s/%s.txt" % ["res://notes", i.old_title])
			var original_title = i.title
			var number = 0
			while(i.title in title_list):
				number += 1
				i.title = "%s%s" % [original_title, number]
			title_list.append(i.title)
			
			var file_name = "%s/%s.txt" % ["res://notes", i.title]
			var error = file.open(file_name, File.WRITE)
			if error == OK:
				file.store_buffer(i.contents.to_utf8())
			file.close()
	refresh()

func refresh():
	note_list.clear()
	for i in notes:
		note_list.add_item(i.title)

func load_data():
	
	# Reinitialize notes
	notes = []
	
	var file = File.new()
	var file_system = Directory.new()
	
	# We should create the directory if it doesn't exist.
	# If it doesn't exist, no point loading any data right?
	if !file_system.dir_exists("res://notes"):
		file_system.make_dir("res://notes")
		return
	
	var error = file_system.open("res://notes")
	
	if error == OK:
		file_system.list_dir_begin(false)
		var file_name = file_system.get_next()
		while(not file_name.empty()):
			
			error = file.open("%s/%s" % [file_system.get_current_dir(), file_name], File.READ)
			if error == OK:
				var contents = file.get_as_text()
				notes.append({"title": file_name.get_basename(), "contents": contents, "has_changed": false, "old_title": file_name.get_basename()})
				file.close()
			
			file_name = file_system.get_next()
		file_system.list_dir_end()
	
	# After we're done, refresh the list.
	refresh()