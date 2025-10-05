class_name Networker extends Node

signal session_start()
signal session_disconnect()
signal connection_failed()


signal connected_to_server()
signal new_peer(id: int)
signal peer_disconnect(id: int)

#DO NOT MODIFY THIS VALUE ANYWHERE ELSE BUT IN THIS SCRIPT PLEASE THANK YOU :) this is why i like private variables from c#
var connected: bool = false

const LAN_IP: String = "127.0.0.1"
const LAN_PORT: int = 55692

#region Initialization
func _ready():
	assign_signals()


func assign_signals():
	multiplayer.connected_to_server.connect(_connected_to_server)
	multiplayer.server_disconnected.connect(_server_disconnected)
	multiplayer.connection_failed.connect(_connection_failed)
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
#endregion

#region Usefuls
var connecting: bool:
	get():                                                                            
		if !multiplayer.multiplayer_peer: return false
		return multiplayer.multiplayer_peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTING
#this variable is more reliable than multiplayer.is_server() in my experience. sometimes certain behavior's gonna be active before & after a game is active but is going to want to know if you are a server or not.
var isServer: bool:
	get():
		if multiplayer.multiplayer_peer == null || multiplayer.multiplayer_peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
			return false
		return multiplayer.is_server()

#endregion

#region Peer Creation
func peer_type_switch(connection_type: Enums.PeerType):
	con_type = connection_type

var con_type: Enums.PeerType

func on_create_server(port: int):
	var peer: MultiplayerPeer
	var err: Error
	match con_type:
		"ENET":
			peer = ENetMultiplayerPeer.new()
			err = peer.create_server(port)
		"WEBSOCKET":
			peer = WebSocketMultiplayerPeer.new()
			err = peer.create_server(port)
		_:
			peer = ENetMultiplayerPeer.new()
			err = peer.create_server(port)
	if err:
		printerr("wtf happened? IDK but cant create the server. port: %s, err: %s" % [port,err])
		return
	multiplayer.multiplayer_peer = peer
	print("Started multiplayer server")
	session_start.emit()
	connected = true

func on_join_server(ip_address: String, port: int):
	var peer: MultiplayerPeer
	var err: Error
	match con_type:
		"ENET":
			peer = ENetMultiplayerPeer.new()
			err = peer.create_client(ip_address,port)
		"WEBSOCKET":
			peer = WebSocketMultiplayerPeer.new()
			err = peer.create_client(ip_address + ":" + str(port))
		_:
			peer = ENetMultiplayerPeer.new()
			err = peer.create_client(ip_address,port)
	if err:
		printerr("wtf happened? IDK but cant join the server. ip: %s, port: %s, err: %s" % [ip_address,port,err])
		return
	multiplayer.multiplayer_peer = peer
	print("attempting to join multiplayer server")
#endregion

#region Multiplayer Signal functions
func _connected_to_server():
	connected_to_server.emit()
	print("connected to server!")
	if !connected:
		connected = true
		session_start.emit()

func _server_disconnected():
	Close()

func _connection_failed():
	connection_failed.emit()

func _on_peer_connected(id: int):
	new_peer.emit(id)

func _on_peer_disconnected(id: int):
	peer_disconnect.emit(id)
#endregion


#region Connection Management functions
func DisconnectPeer(id: int):
	if multiplayer.get_peers().has(id):
		multiplayer.multiplayer_peer.disconnect_peer(id)

func Close():
	if multiplayer.is_server(): print("AAAAAAAAA " + str(connected))
	if multiplayer.multiplayer_peer: multiplayer.multiplayer_peer.close()
	multiplayer.multiplayer_peer = null
	if connected:
		connected = false
		session_disconnect.emit()
#endregion


func _on_multiplayer_test_ui_leave() -> void:
	Close()
