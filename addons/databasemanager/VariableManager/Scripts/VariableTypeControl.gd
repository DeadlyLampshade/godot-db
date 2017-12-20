tool
extends HBoxContainer

const enums = preload("../../Enums.gd")

func _ready():
	set_options_variable_type()
	set_options_data_types()
	$VariableType.connect("item_selected", self, "select_variable_type")

func clean():
	var dict = {"type": $VariableType.get_item_metadata($VariableType.selected)}
	if dict.type == enums.DATA_TYPE.REFERENCE:
		dict.reference = $ReferenceType.get_item_text($ReferenceType.selected)
	return dict

func unclean(variant):
	$VariableType.select(find_base_variable_type(variant.type))
	if variant.type == enums.DATA_TYPE.REFERENCE:
		$ReferenceType.show()
		$ReferenceType.select(find_name(variant.reference))

func find_base_variable_type(value):
	for i in range($VariableType.get_item_count()):
		if $VariableType.get_item_metadata(i) == value:
			return i
			break
	return 0

func find_name(string):
	for i in range($ReferenceType.get_item_count()):
		if $ReferenceType.get_item_text(i) == string:
			return i
	return 0

func select_variable_type(ID):
	match($VariableType.get_item_metadata(ID)):
		enums.DATA_TYPE.REFERENCE:
			$ReferenceType.show()
		_:
			$ReferenceType.hide()

func set_options_data_types():
	$ReferenceType.clear()
	if !get_tree().has_meta("database_manager"):
		return
	for i in get_tree().get_meta("database_manager").data_type:
		$ReferenceType.add_item(i.get_text(0))
	pass

func set_options_variable_type():
	$VariableType.clear()
	for i in enums.DATA_TYPE_LIST:
		$VariableType.add_item("%s-%s" % [i[0], i[1]])
		$VariableType.set_item_metadata($VariableType.get_item_count()-1, i[1])