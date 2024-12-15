class_name TableCell extends Label

@export var cell_data: TableCellData:
	set(value):
		cell_data = value
		_load_text()
		cell_data.connect("changed", _on_cell_data_changed)

func _init() -> void:
	size_flags_horizontal = Control.SIZE_EXPAND_FILL

func _on_cell_data_changed():
	_load_text()

func _load_text():
	text = cell_data.text
