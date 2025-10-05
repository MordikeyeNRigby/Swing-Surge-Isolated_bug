class_name Utils

static func get_world_mouse_pos(viewport: Viewport) -> Vector2:
	var screen_pos: Vector2 = viewport.get_mouse_position()
	return viewport.get_canvas_transform().affine_inverse() * screen_pos

static func vector_projection(vector: Vector2, onto: Vector2) -> Vector2:
	var dot: float = vector.dot(onto)
	return onto * (dot / onto.length_squared())

##this function rotates the vector 90 degrees clockwise. its fast.
static func fast_rotate(vector: Vector2, turns: int) -> Vector2:
	for i: int in turns:
		vector = Vector2(-vector.y,vector.x)
	return vector

#static func set_pin_joint_anchor_state(body: PhysicsBody2D, pin_joint: PinJoint2D, new_position: Vector2, velocity: Vector2 = Vector2.INF):
	#var softness: float = pin_joint.softness
	#if softness > 0:
		#pin_joint.softness = 0.0
	#
	##var node_a = pin_joint.node_a
	##var node_b = pin_joint.node_b
	##pin_joint.node_a = ""
	##pin_joint.node_b = ""
	#if "linear_velocity" in body:
		#var rid: RID = body.get_rid()
		#var new_transform: Transform2D = Transform2D.IDENTITY.translated(new_position)
		#PhysicsServer2D.body_set_state(rid,PhysicsServer2D.BODY_STATE_TRANSFORM,new_transform)
		#if velocity != Vector2.INF: PhysicsServer2D.body_set_state(rid,PhysicsServer2D.BODY_STATE_LINEAR_VELOCITY,velocity)
	#else:
		#body.global_position = new_position
		#body.force_update_transform()
	#pin_joint.softness = softness
	##
	##pin_joint.node_a = node_a
	##pin_joint.node_b = node_b
