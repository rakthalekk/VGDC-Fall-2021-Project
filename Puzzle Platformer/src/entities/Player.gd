class_name Player
extends KinematicBody2D

const FLOOR_NORMAL = Vector2.UP
const FLOOR_DETECT_DISTANCE = 20.0

#const AMOGUS = preload("res://assets/sprites/sus.png")

# The player's speed
export var speed = Vector2(200.0, 700.0)

# The player's velocity
var _velocity = Vector2.ZERO
var coyote = true
var storejump = false
var dead = false

# Gravity constant
onready var gravity = ProjectSettings.get("physics/2d/default_gravity")

# Get references to player's components
onready var animation_player = $AnimationPlayer
onready var sprite = $Sprite
onready var interact_zone = $InteractZone/CollisionShape2D
onready var interact_timer = $InteractZone/InteractTimer
onready var jump_sound = $JumpSound


func _ready():
	if Global.amogus:
		sprite.visible = false
		sprite = $LesserSprite
		sprite.visible = true
		$CollisionShape2D.disabled = true
		$LesserCollider.disabled = false


# Called every frame to process the player's physics
func _physics_process(delta):
	var direction = get_direction()
	
	if is_on_floor():
		coyote = true
		if storejump:
			direction.y = -1
	else:
		coyote_time()
		_velocity.y += gravity * delta
	
	# Variable used for short jumping
	var is_jump_interrupted = Input.is_action_just_released("jump") and _velocity.y < 0.0
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	
	if dead:
		_velocity = Vector2.ZERO
	
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
	
	if Input.is_action_just_pressed("reset"):
		Global.go_next_stage(Global.current_scene)
	
	animation_player.play(get_new_animation())

# Returns the direction vector of the player
func get_direction():
	if !Global.misfortune:
		var direction = Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 0)
		if Input.is_action_just_pressed("jump"):
			storejump = true
			buffer_jump()
			if coyote:
				direction.y = -1
		return direction
		
	else:
		var direction = Vector2(
			Input.get_action_strength("move_left") - Input.get_action_strength("move_right"),
			-1 if (is_on_floor()) and !Input.is_action_pressed("jump") else 0
		)
		if Input.is_action_just_released("jump"):
			if coyote:
				direction.y = -1
		return direction

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


func coyote_time():
	yield(get_tree().create_timer(.075), "timeout")
	coyote = false


func buffer_jump():
	yield(get_tree().create_timer(.1), "timeout")
	storejump = false


func play_jump_sound():
	jump_sound.play()


func kill():
	if !dead:
		$KillTimer.start()
		dead = true


func _on_InteractTimer_timeout():
	interact_zone.disabled = true


func _on_KillTimer_timeout():
	Global.go_next_stage(Global.current_scene)
