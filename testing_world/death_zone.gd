class_name RestrictedZone extends Area2D
#
@export var respawn_point: Node2D
# Called when the node enters the scene tree for the first time.
func _modify(body: Node2D):
	body.global_position = respawn_point.global_position
