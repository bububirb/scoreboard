@tool
class_name ListData extends Resource

@export var items: Array[ListItemData]:
	set(value):
		items = value
		emit_changed()

var selection: Array[ListItemData]:
	set(value):
		selection = value
		emit_changed()

func add_item(item_data: ListItemData):
	items.append(item_data)
	emit_changed()

func remove_item(item_data: ListItemData):
	items.erase(item_data)
	emit_changed()

func find_item(key: String, value):
	for item in items:
		var property = item.get_property(key)
		if property:
			if property.value == value:
				return item
	return null

func deselect(item: ListItemData):
	if item in selection:
		var new_selection = selection.duplicate()
		new_selection.erase(item)
		selection = new_selection

func select(item: ListItemData):
	if item not in selection:
		var new_selection = selection.duplicate()
		new_selection.append(item)
		selection = new_selection
