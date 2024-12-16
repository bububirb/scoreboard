extends Node

@export var players_list: ListData

const PLAYER_DATA_PATH = "user://player_data/"
const PLAYER_DATA_FILE = "players.tres"
const PLAYER_DATA_BACKUP = "players_backup_"

const UNDO_LIMIT = 1000

var undo_step: int = 0
var undo_lock: bool = false

signal players_list_updated

func _init() -> void:
	load_player_data()

func save_player_data() -> void:
	if undo_lock:
		return
	flush_redo()
	var dir = DirAccess.open(PLAYER_DATA_PATH)
	if not dir:
		DirAccess.open("user://").make_dir("player_data")
	var files: Array = dir.get_files()
	files.sort_custom(sort_natural)
	files.reverse()
	for i in files.size():
		dir.rename(files[i], PLAYER_DATA_BACKUP + str(files.size() - i) + ".tres")
	ResourceSaver.save(players_list, PLAYER_DATA_PATH + PLAYER_DATA_FILE)
	flush_undo()

func load_player_data() -> void:
	var dir = DirAccess.open(PLAYER_DATA_PATH)
	if dir:
		if dir.file_exists(PLAYER_DATA_FILE):
			players_list = ResourceLoader.load(PLAYER_DATA_PATH + PLAYER_DATA_FILE, "")
			return
	# If save directory or save file does not exist, create a new one
	players_list = ListData.new()

func load_backup() -> bool:
	var dir = DirAccess.open(PLAYER_DATA_PATH)
	var backup_file: String = PLAYER_DATA_BACKUP + str(undo_step) + ".tres"
	if dir:
		if dir.file_exists(backup_file):
			players_list = ResourceLoader.load(PLAYER_DATA_PATH + backup_file, "", ResourceLoader.CACHE_MODE_REPLACE)
			return true
	return false

func undo() -> void:
	undo_lock = true
	undo_step += 1
	if not load_backup():
		undo_step -= 1
	else:
		players_list_updated.emit()
	undo_lock = false

func redo() -> void:
	undo_step -= 1
	if not load_backup():
		if undo_step == 0:
			load_player_data()
			players_list_updated.emit()
		else:
			undo_step += 1
	else:
		players_list_updated.emit()

func flush_redo() -> void:
	if undo_step < 1:
		return
	var dir = DirAccess.open(PLAYER_DATA_PATH)
	if dir:
		for i in undo_step - 1:
			dir.remove(PLAYER_DATA_BACKUP + str(i + 1) + ".tres")
		
		dir.remove(PLAYER_DATA_FILE)
		dir.rename(PLAYER_DATA_BACKUP + str(undo_step) + ".tres", PLAYER_DATA_FILE)
		
		var files: Array = dir.get_files()
		files.erase(PLAYER_DATA_FILE)
		files.sort_custom(sort_natural)
		for i in files.size():
			dir.rename(files[i], PLAYER_DATA_BACKUP + str(i + 1) + ".tres")
		
		undo_step = 0

func flush_undo():
	var dir = DirAccess.open(PLAYER_DATA_PATH)
	if dir:
		var files: Array = dir.get_files()
		if files.size() > UNDO_LIMIT:
			files.erase(PLAYER_DATA_FILE)
			files.sort_custom(sort_natural)
			files.reverse()
			for i in files.size() - UNDO_LIMIT:
				dir.remove(files[i])

func sort_natural(a: String, b: String) -> bool:
	if a.naturalcasecmp_to(b) == 1:
		return false
	return true
