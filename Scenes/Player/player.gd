extends CharacterBody3D


const SPEED : float = 5.0
const JUMP_VELOCITY : float = 4.5
const ACC : float = 0.5
const DEC : float = 0.5
const GRAVITY : float = 9.8


func _physics_process(delta) -> void:
	
	_handle_movement(delta)


func _handle_movement(delta):
	
	# Add the Gravity.
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Handle Walk.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * SPEED, ACC)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, ACC)
	else:
		velocity.x = move_toward(velocity.x, 0, DEC)
		velocity.z = move_toward(velocity.z, 0, DEC)
	
	move_and_slide()
