@tool
class_name PlayerData extends ListItemData

func _init(name: String = "name", score: int = 0, queue_index: int = 0, streak: int = 0) -> void:
	var name_property = ListItemPropertyData.new("name", name)
	var score_property = ListItemPropertyData.new("score", score)
	var queue_index_property = ListItemPropertyData.new("queue_index", queue_index)
	var streak_property = ListItemPropertyData.new("streak", streak)
	properties = [name_property, score_property, queue_index_property, streak_property]
