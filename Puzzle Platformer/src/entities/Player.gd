extends KinematicBody2D

const FLOOR_NORMAL = Vector2.UP
const FLOOR_DETECT_DISTANCE = 20.0

# The player's speed
export var speed = Vector2(200.0, 700.0)

# The player's velocity
var _velocity = Vector2.ZERO

# Gravity constant
onready var gravity = ProjectSettings.get("physics/2d/default_gravity")

# Get references to player's components
onready var animation_player = $AnimationPlayer
onready var sprite = $Sprite
onready var interact_zone = $InteractZone/CollisionShape2D
onready var interact_timer = $InteractZone/InteractTimer
onready var jump_sound = $JumpSound

# Called every frame to process the player's physics
func _physics_process(delta):
	# Applies gravity
	_velocity.y += gravity * delta
	
	var direction = get_direction()

	# Variable used for short jumping
	var is_jump_interrupted = Input.is_action_just_released("jump") and _velocity.y < 0.0
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	
	# Vertical snap vector for use in move_and_slide_with_snap
	var snap_vector = Vector2.DOWN * FLOOR_DETECT_DISTANCE if direction.y == 0.0 else Vector2.ZERO
	_velocity = move_and_slide_with_snap(
		_velocity, snap_vector, FLOOR_NORMAL, false, 4, 0.9, false
	)
	
	# Sprite scale is flipped if player is moving other direction
	if direction.x != 0:
		sprite.scale.x = -1 if direction.x < 0 else 1 # should be (-)1, 2 once sprite is correct size
	
	if Input.is_action_just_pressed("interact"):
		interact_zone.disabled = false
		interact_timer.start()
	
	animation_player.play(get_new_animation())

# Returns the direction vector of the player
func get_direction():
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1 if (is_on_floor()) and Input.is_action_just_pressed("jump") else 0
	)

# Takes the player's current velocity and applies movement speed and direction
func calculate_move_velocity(
		linear_velocity,
		direction,
		speed,
		is_jump_interrupted
	):
	var velocity = linear_velocity
	velocity.x = speed.x * direction.x
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		velocity.y *= 0.5
	return velocity

# Returns player's current animation
func get_new_animation():
	if _velocity.y < 0:
		return "jump"
	elif _velocity.y > 0:
		return "fall"
	elif abs(_velocity.x) > 0:
		return "move"
	else:
		return "idle"


func play_jump_sound():
	jump_sound.play()


func _on_InteractTimer_timeout():
	interact_zone.disabled = true
