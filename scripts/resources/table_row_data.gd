class_name TableRowData extends Resource

@export var cells: Array[TableCellData]:
	set(value):
		cells = value
		emit_changed()

func add_cell(cell_data: TableCellData):
	cells.append(cell_data)
	emit_changed()
