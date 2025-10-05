extends Control

const LAN_IP: String = Networker.LAN_IP
const LAN_PORT: int = Networker.LAN_PORT

signal join(ip: String, port: int)
signal host(port: int)
signal leave()


@onready var host_join_box: Control = $VBoxContainer/Host_Join
@onready var ip_address_box: LineEdit = $VBoxContainer/IP_Port/IP
@onready var port_box: LineEdit = $VBoxContainer/IP_Port/Port

var ip_address: String:
	get():
		return ip_address_box.text
	set(value):
		ip_address_box.text = value

var port: int:
	get():
		return int(port_box.text)
	set(value):
		port_box.text = str(value)

func _on_lan_host_button_up() -> void:
	host.emit(LAN_PORT)


func _on_lan_join_button_up() -> void:
	join.emit(LAN_IP,LAN_PORT)


func _on_enet_host_button_up() -> void:
	host.emit(port)


func _on_enet_join_button_up() -> void:
	join.emit(ip_address,port)


func _on_leave_button_up() -> void:
	leave.emit()

signal started_session()
signal closed_session()

func _on_networker_session_start() -> void:
	started_session.emit()

func _on_networker_session_disconnect() -> void:
	closed_session.emit()
