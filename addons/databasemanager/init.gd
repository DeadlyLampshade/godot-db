tool
extends EditorPlugin

var DATABASE_MANAGER_CONTROL = preload("DatabaseManager.tscn")
var database_manager

func _enter_tree():
	database_manager = DATABASE_MANAGER_CONTROL.instance()
	get_tree().set_meta("editor_database_manager", self)
	database_manager.visible = false
	get_editor_interface().get_editor_viewport().add_child(database_manager)
	connect("main_screen_changed", self, "change_screen")
	pass

func change_screen(string):
	database_manager.visible = string == get_plugin_name()

func has_main_screen():
	return true

func get_plugin_name():
	return "Database"

func _exit_tree():
	database_manager.free()
	pass