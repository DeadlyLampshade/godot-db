tool
extends VBoxContainer

var name = "" setget set_name

onready var ColorDisplay = $HBoxContainer/ColorRect

onready var RedSlider = $HBoxContainer/VBoxContainer2/RedSlider
onready var GreenSlider = $HBoxContainer/VBoxContainer2/GreenSlider
onready var BlueSlider = $HBoxContainer/VBoxContainer2/BlueSlider

func _ready():
	RedSlider.connect("value_changed", self, "update_color")
	GreenSlider.connect("value_changed", self, "update_color")
	BlueSlider.connect("value_changed", self, "update_color")

func prepare(dict):
	return

func update_color(value):
	ColorDisplay.color = Color8(RedSlider.value, GreenSlider.value, BlueSlider.value, 255)

func set_name(value):
	name = value
	$Label.text = "%s: " % name

func clean():
	return {"red":RedSlider.value,"green":GreenSlider.value,"blue":BlueSlider.value}

func unclean(variant):
	if variant != null:
		RedSlider.value = variant.red
		GreenSlider.value = variant.green
		BlueSlider.value = variant.blue