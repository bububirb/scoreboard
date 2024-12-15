extends Node

@export var players_list: ListData

const PLAYER_DATA_PATH = "user://player_data/"
const PLAYER_DATA_FILE = "players.tres"

func _init() -> void:
	load_player_data()

func save_player_data():
	var dir = DirAccess.open(PLAYER_DATA_PATH)
	if not dir:
		DirAccess.open("user://").make_dir("player_data")
	ResourceSaver.save(players_list, PLAYER_DATA_PATH + PLAYER_DATA_FILE)


func load_player_data() -> void:
	var dir = DirAccess.open(PLAYER_DATA_PATH)
	if dir:
		if dir.file_exists(PLAYER_DATA_FILE):
			players_list = ResourceLoader.load(PLAYER_DATA_PATH + PLAYER_DATA_FILE)
			return
	# If save directory or save file does not exist, create a new one
	players_list = ListData.new()
	
