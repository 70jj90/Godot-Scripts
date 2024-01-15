# Godot 4.X : Ultimate First Person Controller Tutorial ( 2023 ) by Lukky
# https://youtu.be/xIKErMgJ1Yk?si=yJrQXvipBZlccsck

extends CharacterBody3D

@onready var head_node_3d = $HeadNode3D

# Keyboard setup:
var current_speed = 5.0

const walking_speed = 5.0
const sprinting_speed = 10.0
const crouching_speed = 3.0

const jump_velocity = 4.5

# Mouse setup:
const mouse_sensitivity = 0.25

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event): 
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		head_node_3d.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))	
		head_node_3d.rotation.x = clamp(head_node_3d.rotation.x,deg_to_rad(-89), deg_to_rad(89))		

func _physics_process(delta):
	
	if Input.is_action_pressed('sprint'):
		current_speed = sprinting_speed
	else: 
		current_speed = walking_speed
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()
