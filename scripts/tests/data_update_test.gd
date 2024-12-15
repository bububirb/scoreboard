extends Control

@export var list_data: ListData

var counter: float = 0.0

func _process(delta: float) -> void:
	counter += delta
	if randf() > 0.99:
		print("!")
		var list_item_data = ListItemData.new()
		var list_iem_property_data = ListItemPropertyData.new("value", 0.0)
		list_item_data.add_property(list_iem_property_data)
		list_data.add_item(list_item_data)
		print_tree_pretty()
	if list_data:
		for item_data in list_data.items:
			for property in item_data.properties:
				property.value = str(counter * randf())
