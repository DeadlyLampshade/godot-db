tool
extends PanelContainer

func clean():
	return {"row_count": $VBoxContainer/HBoxContainer/RowCount.value, "contents": $VBoxContainer/MainContainer.clean()}

func unclean(data):
	if data != null:
		$VBoxContainer/HBoxContainer/RowCount.value = data.row_count
		$VBoxContainer/MainContainer.unclean(data.contents)