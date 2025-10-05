class_name PlayerInput extends BaseNetInput

var mouse_pos: Vector2 = Vector2.ZERO

var movement: Vector2

var lclick_init: bool
var lclick_release: bool

var rclick_init: bool
var rclick_release: bool

var jump_init: bool
var jump_release: bool

#region buffer vars
var lclick_init_buffer: bool
var lclick_release_buffer: bool
var rclick_init_buffer: bool
var rclick_release_buffer: bool
var jump_init_buffer: bool
var jump_release_buffer: bool
var movement_buffer: Vector2
var movement_buffer_count: int
#endregion



func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("LClick"):
		lclick_init_buffer = true
	if Input.is_action_just_released("LClick"):
		lclick_release_buffer = true
	if Input.is_action_just_pressed("RClick"):
		rclick_init_buffer = true
	if Input.is_action_just_released("RClick"):
		rclick_release_buffer = true
	if Input.is_action_just_pressed("Jump"):
		jump_init_buffer = true
	if Input.is_action_just_released("Jump"):
		jump_release_buffer = true
	
	var move =  Vector2(Input.get_axis("Left","Right"),Input.get_axis("Up","Down"))
	if move != Vector2.ZERO:
		movement_buffer_count += 1
		movement_buffer += move


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _gather():
	mouse_pos = Utils.get_world_mouse_pos(get_viewport())
	if movement_buffer_count == 0: movement = Vector2(Input.get_axis("Left","Right"),Input.get_axis("Up","Down"))
	else:
		movement = movement_buffer / movement_buffer_count
		movement_buffer = Vector2.ZERO
		movement_buffer_count = 0
	
	jump_init = jump_init_buffer
	jump_init_buffer = false
	
	jump_release = jump_release_buffer
	jump_release_buffer = false
	
	lclick_init = lclick_init_buffer
	lclick_init_buffer = false
	
	lclick_release = lclick_release_buffer
	lclick_release_buffer = false

	rclick_init = rclick_init_buffer
	rclick_init_buffer = false
	
	rclick_release = rclick_release_buffer
	rclick_release_buffer = false
