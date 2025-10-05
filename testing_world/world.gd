class_name World extends Node2D

@onready var multiplayer_spawner: MultiplayerSpawner = $MultiplayerSpawner

var server_spawned: bool = false

func _on_networker_new_peer(id: int) -> void:
	if !multiplayer.is_server() || !multiplayer_spawner.has_method(&"spawn_character"): return
	if !server_spawned:
		multiplayer_spawner.spawn_character(1)
		server_spawned = true
	multiplayer_spawner.spawn_character(id)


func _on_networker_session_disconnect() -> void:
	multiplayer_spawner.delete_all()
	server_spawned = false
