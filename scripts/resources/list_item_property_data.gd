@tool
class_name ListItemPropertyData extends Resource

func _init(init_key: String = "key", init_value = "value") -> void:
	key = init_key
	value = init_value

@export var key: String:
	set(new_value):
		key = new_value
		emit_changed()

@export var value = "":
	set(new_value):
		value = new_value
		emit_changed()
