class_name RestrictedZone extends NetworkArea2D
#
@export var respawn_point: Node2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rollback_body_entered.connect(_on_entered)



func _on_entered(body: Node2D, __tick: int):
	if body is not TestingCharacter: return
	print("found body")
	var c: TestingCharacter = body
	c.death_flag = true
	c.respawn_point = respawn_point.global_position
	#NetworkRollback.mutate(c)
	#is called now by the networkarea2d and it should work
	#c.global_position = respawn_point.global_position
	#c.velocity = Vector2.ZERO
	#c.move_and_slide()
	#is called by the character in its own rollback loop
	#c.death_callable = func():
		#print("running death callable")
		#c.global_position = respawn_point.global_position
		#c.velocity = Vector2.ZERO
		#NetworkRollback.mutate(c)
