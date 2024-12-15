@tool
class_name ListItemData extends Resource

@export var properties: Array[ListItemPropertyData]:
	set(value):
		properties = value
		emit_changed()

func add_property(property: ListItemPropertyData):
	properties.append(property)
	emit_changed()

func get_property(key: String) -> ListItemPropertyData:
	for property in properties:
		if property.key == key:
			return property
	return null

func set_property(key: String, value):
	for property in properties:
		if property.key == key:
			property.value = value
