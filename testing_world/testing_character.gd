class_name TestingCharacter extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var input: PlayerInput = $PlayerInput
var peer_id: int
@onready var synchronizer: RollbackSynchronizer = $RollbackSynchronizer
var death_flag: bool = false
var respawn_point: Vector2
func not_dead():
	pass
func _ready():
	set_multiplayer_authority(1)
	$PlayerInput.set_multiplayer_authority(peer_id)
	$RollbackSynchronizer.process_settings()

func _rollback_tick(delta: float, _tick: int, _fresh: bool) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if input.jump_init and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := input.movement.x
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if death_flag:
		global_position = respawn_point
		death_flag = false
		print("death")
		
	velocity *= NetworkTime.physics_factor
	move_and_slide()
	velocity /= NetworkTime.physics_factor
	
