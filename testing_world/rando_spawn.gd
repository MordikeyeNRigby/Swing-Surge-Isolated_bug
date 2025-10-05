class_name RandomPosition extends Node2D
##ensures 

@onready var last_position: Node2D = _sample_rando()

func _ready():
	for child: Node in get_children():
		if child is not Node2D:
			child.queue_free()

func get_random_position() -> Vector2:
	var new_pos: Node2D = _sample_rando()
	while last_position == new_pos:
		new_pos = _sample_rando()
	last_position = new_pos
	return new_pos.global_position

func _sample_rando() -> Node2D:
	return get_children().pick_random()
