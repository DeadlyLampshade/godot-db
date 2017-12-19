tool
extends VBoxContainer

onready var variable_type = $TopBar/VariableType
onready var BonusPanel = $BonusOptions

func move_up():
	var current_position = get_position_in_parent()
	if current_position > 0: get_parent().move_child(self, get_position_in_parent() - 1)

func move_down():
	var current_position = get_position_in_parent()
	var child_count = get_parent().get_child_count()-1
	if current_position < child_count: get_parent().move_child(self, get_position_in_parent() + 1)

func delete_control():
	print(_clean())
	queue_free()

func _clean():
	return {"type":variable_type.clean()}

func _unclean(variant):
	variable_type.unclean(variant.type)