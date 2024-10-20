extends CharacterBody2D
## This Player class represents the basic player controller and builds off of 
## CharacterBody2D functionality. This class provides a variety of methods for you to be
## able to extend and override if you wanted to modify the player's functionality, as well as
## several quantities for you to tweak to change the feel of the player controller
class_name Player

const INPUT_THRESHOLD: float = 0.01
const STOP_VELOCITY_THRSHOLD: float = 0.01

@export_category("Movement Config")
## This quantity represents the player's maximum horizontal speed in pixels/sec
@export var max_horizontal_speed: float = 50
## The acceleration constant is used to speed the player up to their maximum speed, and this quantity
## is given in pixels/sec^2.
@export var acceleration: float = 500
## The deceleration constant is used to slow the player down when there is no player input. I give this
## a separate variable in case you want the player to slow down faster than they speed up for more precise
## movement. You can always set this quantity to be the same as the acceleration constant if not.
@export var deceleration: float = 1000
## When jumping the player's y-velocity is set to this amount (units in pixels/sec). Using kinematics
## you can about approximate the player's max jump height to be equal to this quantity in pixels
## (assuming the gravitational constant is fixed to 9.8 pixels/sec^2)
@export var jump_strength: float = 20
## This is the player's gravitational constant in pixels/sec^2. The player will constantly be experiencing
## this downward acceleration when they are not grounded (default behavior). You can increase this 
## constant to increase the magnitude of the player's downward acceleration (make the player heavier).
@export var gravity: float = 9.8
## This is the player's maximum fall speed, and will be used the clamp the player's negative velocity
## so that they don't accelerate past this speed while in freefall
@export var max_fall_speed: float = 50


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous physics frame.
func _physics_process(delta):
	
	var direction = Input.get_axis("player_left", "player_right")
	move_horizontal(direction, delta)
	
	if Input.is_action_just_pressed("player_jump") and can_jump():
		jump()
	
	if !is_on_floor():
		apply_gravity(delta)
		
	move_and_slide()


## Takes a horizontal input value and calculates player horizontal movement accordingly. This 
## function automatically handles acceleration and deceleration of the player when there is/isn't
## user input respectively
func move_horizontal(input: float, delta: float):
	if abs(input) < INPUT_THRESHOLD and abs(velocity.x) > 0:
		velocity.x += -sign(velocity.x) * deceleration * delta
		if abs(velocity.x) < STOP_VELOCITY_THRSHOLD:
			velocity.x = 0
	elif abs(velocity.x) < max_horizontal_speed:
		velocity.x += input * acceleration * delta
		if abs(velocity.x) > max_horizontal_speed:
			velocity.x = sign(input) * max_horizontal_speed


## Call this function to execute a jump, this function applies an impulse to the player body based
## on the 
func jump() -> void:
	velocity.y = -jump_strength


## This function is called to both apply the gravitational acceleration to the player and clamp the 
## player's gravitational acceleration to their maximum fall speed.
func apply_gravity(delta: float) -> void:
	# Not a necessary optimization but only apply gravity if the player's fall speed is not at its maximum
	if velocity.y < max_fall_speed:
		velocity.y += delta * gravity
		
		# Clamp the player's velocity to this lower bound
		if velocity.y > max_fall_speed:
			velocity.y = max_fall_speed


## This function is called to check if the player is able to jump. By default this is true if the 
## player is grounded, but this function can be overridden to give the player controller unique jump
## behavior without modifying the player's _process function. For example, double jumping can be implemented
## by allowing the player to jump once in the air. A counter can be used to track how many times
## the player has jumped while not grounded, and this can return true when that counter is 0 (or some
## other arbitrary value depending on how many jumps the player is allowed before needing to land).
func can_jump() -> bool:
	return is_on_floor()
