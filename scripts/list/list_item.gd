@tool
class_name ListItem extends Control

signal clicked

@export var item_data: ListItemData:
	set(value):
		item_data = value
		_load_item_data()
		if item_data and not item_data.changed.is_connected(_on_item_data_changed):
			item_data.changed.connect(_on_item_data_changed)

var selected: bool = false:
	set(value):
		selected = value
		selection_highlight.visible = selected

var visible_columns: Dictionary = {}

@onready var selection_button: Button = $SelectionButton
@onready var selection_highlight: Panel = $SelectionHighlight

func _ready() -> void:
	selection_button.pressed.connect(_on_selection_button_pressed)

func _on_selection_button_pressed() -> void:
	clicked.emit(item_data)

func _on_item_data_changed() -> void:
	_load_item_data()

func _load_item_data() -> void:
	_clear()
	if item_data:
		for property_data in item_data.properties:
			_add_property(property_data)

func _clear() -> void:
	for item in %Items.get_children():
		item.queue_free()

func _add_property(property_data: ListItemPropertyData) -> void:
	var property = ListItemProperty.new()
	property.property_data = property_data
	if visible_columns:
		if property_data.key in visible_columns:
			property.visible = visible_columns[property_data.key]
		else:
			property.visible = false
	%Items.add_child(property)
