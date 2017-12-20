tool
extends PanelContainer

func clean():
	return {"row_count": $VBoxContainer/HBoxContainer/RowCount.value, "contents": $VBoxContainer/MainContainer.clean()}

func unclean(data):
	if data != null:
		$VBoxContainer/HBoxContainer/RowCount.value = data.row_count
		$VBoxContainer/MainContainer.unclean(data.contents)

func click_hide_button():
	$VBoxContainer/MainContainer.visible = !$VBoxContainer/MainContainer.visible
	$VBoxContainer/HBoxContainer/Button.text = "Show" if $VBoxContainer/MainContainer.visible else "Hide"
	pass # replace with function body
