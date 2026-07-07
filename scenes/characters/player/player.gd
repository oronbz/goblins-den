class_name Player
extends CharacterBody3D

const MAX_ANGLE_LOOK_UP := deg_to_rad(70)
const MAX_ANGLKE_LOOK_DOWN := deg_to_rad(-70)

@export var acceleration: float
@export var jump_force: float
@export var gravity: float
@export var mouse_sensitivity: float
@export var gamepad_sensitivity: float
@export var walk_speed: float
@export var run_speed: float

@onready var camera: Camera3D = %Camera3D

var input_dir := Vector2.ZERO

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(_delta: float) -> void:
	input_dir = Input.get_vector("strafe_left", "strafe_right", "backward", "forward")
	var rotation_dir := Input.get_vector("look_left", "look_right", "look_up", "look_down")
	
	if rotation_dir != Vector2.ZERO:
		look(rotation_dir, gamepad_sensitivity)

func _physics_process(delta: float) -> void:
	check_jump_input()
	process_gravity()
	
	var input_3d_space := Vector3(input_dir.x, 0, -input_dir.y)
	var speed := run_speed if Input.is_action_pressed("run") else walk_speed
	var desired_velocity := transform.basis * input_3d_space * speed
	velocity.x = move_toward(velocity.x, desired_velocity.x, acceleration * delta)
	velocity.z = move_toward(velocity.z, desired_velocity.z, acceleration * delta)

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look(event.relative, mouse_sensitivity)

func look(direction: Vector2, sensitivity: float) -> void:
	rotate_y(-direction.x * sensitivity)
	camera.rotate_x(-direction.y * sensitivity)
	camera.rotation.x = clampf(camera.rotation.x, MAX_ANGLKE_LOOK_DOWN, MAX_ANGLE_LOOK_UP)

func check_jump_input() -> void:
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_force

func process_gravity() -> void:
	if not is_on_floor():
		velocity.y -= gravity

#const SPEED = 5.0
#const JUMP_VELOCITY = 4.5
#
#
#func _physics_process(delta: float) -> void:
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)
#
	#move_and_slide()
