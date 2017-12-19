# godot-db
A general purpose JSON database system for Godot. This plugin should run on Godot 3.0 beta and up.

Installation is simple, simply drag this file into your "res://addons/" folder of your project and activate from your project settings.

This is an indevelopment project intended to help people in making databases for games, and is not specific to one type of game...

# How does it work
This is a main screen plugin for Godot. As soon as you activate it, you will see an option for "Database". I am aware there's an error icon, the version of godot I used to make this doesn't expose icon setting.

When you enter the tab you will be greeted to an empty tree, and a few buttons. One to add a DataType and one to add an item. You need a new data type to add an item, so do that first by pressing the "Add DataType" button. You can set the name of the datatype when selected via the text box on the top.

# How do I load the data
The process of loading data for use in your game is simple process. As this snippet will demonstrate, this script loads a .json file at "res://data/" named Weapons and stores it under the "weapons" key in the data dictionary.

```
extends Node

var data = {}

func _ready():
    load_weapon_settings()

func load_weapon_settings():
    var file = File.new()
    if file.open("res://data/Weapons.json", File.READ) == OK:
        data.weapons = JSON.parse(file.get_as_text()).result.contents
    file.close()
```

Whenever you want to access an item, for example, IronSword, you would access it through data.weapons.IronSword
