class_name TableData extends Resource

@export var rows: Array[TableRowData]:
	set(value):
		rows = value
		emit_changed()

func add_row(row_data: TableRowData):
	rows.append(row_data)
	emit_changed()
