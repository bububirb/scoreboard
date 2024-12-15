class_name TableRow extends HBoxContainer

@export var row_data: TableRowData:
	set(value):
		row_data = value
		_load_cells()
		row_data.connect("changed", _on_row_data_changed)

func _init() -> void:
	custom_minimum_size.y = 32

func _on_row_data_changed():
	_load_cells()

func _load_cells():
	_clear()
	for cell_data in row_data.cells:
		_add_cell(cell_data)

func _clear():
	for cell in get_children():
		cell.queue_free()

func _add_cell(cell_data: TableCellData):
	var table_cell = TableCell.new()
	table_cell.cell_data = cell_data
	add_child(table_cell)
