class_name TableCellData extends Resource

@export var text = "":
	set(value):
		text = value
		emit_changed()
