class_name ListItemProperty extends Label

@export var property_data: ListItemPropertyData:
	set(value):
		property_data = value
		_load_value()
		property_data.connect("changed", _on_property_data_changed)

func _init() -> void:
	size_flags_horizontal = Control.SIZE_EXPAND_FILL

func _on_property_data_changed():
	_load_value()

func _load_value():
	text = str(property_data.value)
