class_name TestingSpawner extends MultiplayerSpawner

@export var player_scene: PackedScene
@export var camera: Camera2D
@export var random_position: RandomPosition
var characters: Dictionary[int,Node2D]

func _ready():
	spawn_function = _spawn_function
	multiplayer.peer_disconnected.connect(func(id: int):
		if characters.has(id):
			characters[id].queue_free()
		)

#func _process(delta: float) -> void:
	#if characters.size() == 0

func spawn_character(id: int) -> Node2D:
	if !multiplayer.is_server(): return null
	return spawn({
		"peer_id": id,
		"global_position": random_position.get_random_position()
	})

func _spawn_function(data: Dictionary) -> Node2D:
	var new_player: Node2D = player_scene.instantiate()
	if (!data.has("peer_id") ||
		!data.has("global_position") || 
		"peer_id" not in new_player ||
		!new_player.has_signal(&"tree_exiting")):
			printerr("yea there arent the proper conditions for player spawning. see the code in the next print")
			print_debug("see the code here")
			return
	
	
	new_player.peer_id = data.peer_id
	new_player.global_position = data.global_position
	#add them to the organizing array
	characters[new_player.peer_id] = new_player
	#and set the multiplayer authority
	new_player.set_multiplayer_authority(new_player.peer_id)
	#then hook up the new player to remove itself from the dictionary if it dies
	new_player.tree_exiting.connect(func():
		if characters.has(new_player.peer_id):
			characters.erase(new_player.peer_id)
		)
	#if ur spawning urself, put the camera in the character and set up the camera to reset itself when its queue_free'd.
	if new_player.peer_id == multiplayer.get_unique_id():
		camera.reparent(new_player)
		camera.position = Vector2.ZERO
		new_player.tree_exiting.connect(func():
			camera.reparent(get_parent())
			camera.position = get_viewport().get_visible_rect().size / 2
			)
	return new_player

func delete_all():
	for p: TestingCharacter in characters.values():
		p.queue_free()
