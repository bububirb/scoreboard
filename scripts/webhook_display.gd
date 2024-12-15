extends PanelContainer

@export var list_data: ListData:
	set(new_list_data):
		list_data = new_list_data
		players_list.list_data = list_data

var player_1: PlayerData:
	set(player):
		player_1 = player
		if player_1 and player_2:
			update_next_match_label()

var player_2: PlayerData:
	set(player):
		player_2 = player
		if player_1 and player_2:
			update_next_match_label()

@onready var players_list: List = $PanelContainer/VBoxContainer/PlayersList
@onready var next_match_label: Label = $PanelContainer/VBoxContainer/NextMatchContainer/NextMatchLabel

func update_next_match_label():
	next_match_label.text = player_1.get_property("name").value + " vs " + player_2.get_property("name").value
