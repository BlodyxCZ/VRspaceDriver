extends CharacterBody3D


const SPEED : float = 5.0
const JUMP_VELOCITY : float = 4.5
const ACC : float = 0.5
const DEC : float = 0.5
const GRAVITY : float = 9.8

@export var mouse_sensitivity : float = 0.2

@onready var camera : Camera3D = $Camera3D


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta) -> void:
	
	_handle_movement(delta)
	
	if Input.is_action_just_pressed("ui_cancel"):
		if !Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _handle_movement(delta) -> void:
	
	# Add the Gravity.
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Handle Walk.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized().rotated(Vector3.UP, camera.rotation.y)
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * SPEED, ACC)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, ACC)
	else:
		velocity.x = move_toward(velocity.x, 0, DEC)
		velocity.z = move_toward(velocity.z, 0, DEC)
	
	move_and_slide()


func _input(event) -> void:
	if event is InputEventMouseMotion && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		camera.rotation_degrees.y = wrapf(camera.rotation_degrees.y, 0.0, 360.0)
		camera.rotation_degrees.y -= event.relative.x * mouse_sensitivity
		
		camera.rotation_degrees.x = clampf(camera.rotation_degrees.x, -80.0, 80.0)
		camera.rotation_degrees.x -= event.relative.y * mouse_sensitivity
