@tool
class_name List extends VBoxContainer

@export var headers: ListItemData:
	set(value):
		headers = value
		if not headers.changed.is_connected(_on_headers_changed):
			headers.changed.connect(_on_headers_changed)
		notify_property_list_changed()

@export var list_data: ListData:
	set(value):
		list_data = value
		if is_node_ready():
			_load_items()
			if not list_data.changed.is_connected(_on_list_data_changed):
				list_data.changed.connect(_on_list_data_changed)

@export var sort_property: String
@export var sort_reversed: bool = false

var visible_columns: Dictionary = {}

var list_item_scene = preload("res://scenes/list/list_item.tscn")

var selection: Array[ListItemData]:
	set(value):
		selection = value
		_update_selection()

func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	
	if headers != null:
		if headers.properties.size() > 0:
			for property in headers.properties:
				if property != null:
					properties.append({
						"name": "show_column_%s" % property.key,
						"type": TYPE_BOOL,
					})
	
	return properties

func _get(property):
	if property.begins_with("show_column_"):
		var key = property.trim_prefix("show_column_")
		if key in visible_columns:
			return visible_columns[key]
		else:
			return false

func _set(property, value):
	if property.begins_with("show_column_"):
		var key = property.trim_prefix("show_column_")
		visible_columns[key] = value
		return true
	return false

func _on_list_data_changed() -> void:
	_load_items()
	_update_selection()

func _on_headers_changed() -> void:
	flush_columns()
	notify_property_list_changed()

func flush_columns() -> void:
	var properties: Array = []
	for property in headers.properties:
		if property != null:
			properties.append(property.key)
			if property.key not in visible_columns:
				visible_columns[property.key] = false
	for key in visible_columns.keys():
		if key not in properties:
			visible_columns.erase(key)

func _on_list_item_clicked(item_data: ListItemData) -> void:
	if Input.is_key_pressed(KEY_SHIFT):
		if item_data in list_data.selection:
			list_data.deselect(item_data)
		else:
			list_data.select(item_data)
	else:
		select(item_data)

func get_items() -> Array[Node]:
	return get_children()

func _load_items() -> void:
	_clear()
	var list_items = list_data.items.duplicate()
	if sort_property:
		list_items.sort_custom(sort_list_items)
	for item_data in list_items:
		_add_item(item_data)

func _clear() -> void:
	for item in get_children():
		item.queue_free()

func _add_item(item_data: ListItemData) -> void:
	var list_item = list_item_scene.instantiate()
	add_child(list_item)
	list_item.clicked.connect(_on_list_item_clicked)
	list_item.visible_columns = visible_columns
	list_item.item_data = item_data

func select(item: ListItemData):
	list_data.selection = [item]

func _update_selection():
	for item in get_items():
		item.selected = item.item_data in list_data.selection

func sort_list_items(a: ListItemData, b: ListItemData):
	if a.get_property(sort_property).value < b.get_property(sort_property).value:
		if sort_reversed:
			return false
		return true
	if sort_reversed:
		return true
	return false
