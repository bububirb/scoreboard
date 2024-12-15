extends Control

@export var players_list: ListData:
	set(value):
		players_list = value
		if not players_list.changed.is_connected(_on_players_list_changed):
			players_list.changed.connect(_on_players_list_changed)
		
		if is_node_ready():
			queue_list.list_data = players_list
			players.list_data = players_list
			leaderboard_list.list_data = players_list
			webhook_display.list_data = players_list

var selected_player: int = 0
var player_1: PlayerData:
	set(player):
		player_1 = player
		player_1_button.text = player_1.get_property("name").value
		webhook_display.player_1 = player_1

var player_2: PlayerData:
	set(player):
		player_2 = player
		player_2_button.text = player_2.get_property("name").value
		webhook_display.player_2 = player_2

@onready var player_1_button: Button = $HBoxContainer/CenterTabContainer/Match/CurrentMatchPanel/MatchPlayersContainer/Player1Button
@onready var player_2_button: Button = $HBoxContainer/CenterTabContainer/Match/CurrentMatchPanel/MatchPlayersContainer/Player2Button

@onready var discord_webhook: Node = $DiscordWebhook
@onready var render_viewport: SubViewport = %RenderViewport

@onready var queue_list: List = $HBoxContainer/LeftTabContainer/Queue/MarginContainer/QueueList
@onready var players: VBoxContainer = $HBoxContainer/CenterTabContainer/Players
@onready var leaderboard_list: List = $HBoxContainer/RightTabContainer/Leaderboard/MarginContainer/LeaderboardList
@onready var webhook_display: PanelContainer = $RenderViewport/WebhookDisplay

func _ready() -> void:
	players_list = IO.players_list
	assign_match_players()

func _on_players_list_changed():
	assign_match_players()
	IO.save_player_data.call_deferred()

func _on_player_button_pressed(index: int) -> void:
	selected_player = index

func _on_commit_button_pressed() -> void:
	if players_list.items.size() >= 2:
		if selected_player == -1:
			advance_queue_draw()
		else:
			advance_queue(get_winning_player(), get_losing_player())
	assign_match_players()
	player_1_button.button_pressed = true
	selected_player = 0
	players_list.changed.emit()
	
	send_to_webhook()

func send_to_webhook() -> void:
	await RenderingServer.frame_post_draw
	var image = render_viewport.get_texture()
	discord_webhook.send_image(image)

func advance_queue(winning_player: PlayerData, losing_player: PlayerData):
	winning_player.get_property("streak").value += 1
	losing_player.set_property("streak", 0)
	
	winning_player.get_property("score").value += 1
	
	move_to_queue_bottom(losing_player)
	if winning_player.get_property("streak").value >= 3:
		move_to_queue_bottom(winning_player)
		winning_player.set_property("streak", 0)
	else:
		winning_player.set_property("queue_index", 0)

func advance_queue_draw():
	player_1.set_property("streak", 0)
	player_2.set_property("streak", 0)
	
	move_to_queue_bottom(player_1)
	move_to_queue_bottom(player_2)

func move_to_queue_bottom(player: PlayerData):
	for item in players_list.items:
		var property = item.get_property("queue_index")
		property.value -= 1
	player.set_property("queue_index", players_list.items.size() - 1)

func get_winning_player() -> PlayerData:
	if selected_player != -1:
		return get("player_" + str(selected_player + 1))
	return null

func get_losing_player() -> PlayerData:
	if selected_player != -1:
		return get("player_" + str(2 - selected_player))
	return null

func find_nth_player(index: int) -> ListItemData:
	var sorted_items: Array[ListItemData] = players_list.items.duplicate()
	sorted_items.sort_custom(sort_to_queue)
	var player: PlayerData = sorted_items[index]
	return player

func sort_to_queue(a: ListItemData, b: ListItemData):
	if a.get_property("queue_index").value < b.get_property("queue_index").value:
		return true
	return false

func assign_match_players():
	if players_list.items.size() >= 2:
		player_1 = find_nth_player(0)
		player_2 = find_nth_player(1)
