extends VBoxContainer

@export var list_data: ListData:
	set(new_list_data):
		list_data = new_list_data
		players_list.list_data = list_data

@onready var player_name_input: LineEdit = %PlayerNameInput
@onready var add_player_button: Button = %AddPlayerButton
@onready var players_list: List = %PlayersList

func _ready() -> void:
	player_name_input.text_submitted.connect(_on_player_name_input_submitted)
	add_player_button.pressed.connect(_on_add_player_button_pressed)

func _on_player_name_input_submitted(new_text: String) -> void:
	add_player(new_text)

func _on_add_player_button_pressed() -> void:
	add_player(player_name_input.text)

func _on_remove_button_pressed() -> void:
	for player_data in players_list.list_data.selection:
		_remove_player(player_data)

func _on_move_up_button_pressed() -> void:
	var sorted_selection = sort_players(players_list.list_data.selection)
	for player in sorted_selection:
		var player_1 = player
		if player_1.get_property("queue_index").value > 0:
			var player_2 = find_nth_player(player_1.get_property("queue_index").value - 1)
			if not player_2 in sorted_selection:
				player_1.get_property("queue_index").value -= 1
				player_2.get_property("queue_index").value += 1
	players_list.list_data.emit_changed()

func _on_move_down_button_pressed() -> void:
	var sorted_selection = sort_players(players_list.list_data.selection)
	sorted_selection.reverse()
	for player in sorted_selection:
		var player_1 = player
		if player_1.get_property("queue_index").value < players_list.list_data.items.size() - 1:
			var player_2 = find_nth_player(player_1.get_property("queue_index").value + 1)
			if not player_2 in sorted_selection:
				player_1.get_property("queue_index").value += 1
				player_2.get_property("queue_index").value -= 1
	players_list.list_data.emit_changed()

func add_player(player_name: String) -> void:
	player_name = player_name.strip_edges()
	if player_name != "":
		var new_player_data = PlayerData.new(player_name, 0, players_list.list_data.items.size())
		_add_player(new_player_data)

func sort_players_list() -> void:
	var sorted_players_list: Array[ListItemData] = players_list.list_data.items.duplicate()
	sorted_players_list.sort_custom(sort_to_queue)
	for i in sorted_players_list.size():
		sorted_players_list[i].set_property("queue_index", i)

func sort_players(players: Array[ListItemData]) -> Array[ListItemData]:
	var sorted_players: Array[ListItemData] = players.duplicate()
	sorted_players.sort_custom(sort_to_queue)
	return sorted_players

func find_nth_player(index: int) -> ListItemData:
	var sorted_items: Array[ListItemData] = players_list.list_data.items.duplicate()
	sorted_items.sort_custom(sort_to_queue)
	var player: PlayerData = sorted_items[index]
	return player

func sort_to_queue(a: ListItemData, b: ListItemData):
	if a.get_property("queue_index").value < b.get_property("queue_index").value:
		return true
	return false


func _add_player(player_data: PlayerData) -> void:
	sort_players_list()
	players_list.list_data.add_item(player_data)
	player_name_input.clear()

func _remove_player(player_data: PlayerData) -> void:
	players_list.list_data.remove_item(player_data)
	sort_players_list()
