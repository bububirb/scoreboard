class_name Table extends VBoxContainer

@export var table_data: TableData:
	set(value):
		table_data = value
		_load_rows()
		table_data.connect("changed", _on_table_data_changed)

func _on_table_data_changed():
	_load_rows()

func _load_rows():
	_clear()
	for row_data in table_data.rows:
		_add_row(row_data)

func _clear():
	for row in get_children():
		row.queue_free()

func _add_row(row_data: TableRowData):
	var table_row = TableRow.new()
	table_row.row_data = row_data
	add_child(table_row)
