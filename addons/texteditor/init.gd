tool
extends EditorPlugin

var NOTEPAD = preload("scene.tscn")
var notepad_scene
var initial_load = false

func _enter_tree():
	instantiate_notepad()
	get_editor_interface().get_editor_viewport().add_child(notepad_scene)
	connect("main_screen_changed", self, "show_notepad")
	pass

func has_main_screen():
	return true

func get_plugin_name():
	return "Notepad"

func _exit_tree():
	notepad_scene.free()
	pass

func show_notepad(scene_name):
	notepad_scene.visible = scene_name == get_plugin_name()
	if initial_load == false:
		notepad_scene.load_data()
		initial_load = true

func instantiate_notepad():
	notepad_scene = NOTEPAD.instance()
	notepad_scene.EDITORPLUGIN = self
	notepad_scene.visible = false