

extends CharacterBody2D

@export var speed = 232 * 1.5
@export var jump_speed = -364 * 1.5
@export var gravity = 140 * 9.8 * 1.5
@export var jumps_count: int = 2

@export_range(0.0, 1.0) var friction = 0.32
@export_range(0.0, 1.0) var acceleration = 0.32

var is_jumping = false
var is_attacking = false
var jumps_used = 0


var is_climbing: bool = false

func _ready():
	add_to_group("players")


func _physics_process(delta):
	var dir = Input.get_axis("ui_left", "ui_right")
	
	if not is_climbing:
		velocity.y += gravity * delta # Apply gravity
		
		if dir != 0: # Movement
			if is_on_floor():
				velocity.x = lerp(velocity.x, dir * speed, acceleration)
			else:
				velocity.x = lerp(velocity.x, dir * speed * 1.4, acceleration)
			if dir > 0:
				$AnimatedSprite2D.flip_h = false
			else:
				$AnimatedSprite2D.flip_h = true
			if not is_attacking:
				$AnimatedSprite2D.play("run")
		else:
			velocity.x = lerp(velocity.x, 0.0, friction)
			if not is_attacking:
				$AnimatedSprite2D.play("idle")

	# Double Jump
	if not is_climbing:
		if Input.is_action_just_pressed("ui_up") and (is_on_floor() or jumps_used < jumps_count - 1):
			velocity.y = jump_speed
			jumps_used += 1
			is_jumping = true

	# Animation and Jumping State
	if not is_climbing:
		if is_jumping:
			if is_on_floor():
				jumps_used = 0
				is_jumping = false
			if not is_attacking:
				$AnimatedSprite2D.play("fall")

	# Attack
	if Input.is_action_just_pressed("ui_home"):
		is_attacking = true
	if is_attacking:
		$AnimatedSprite2D.play("attack")
	
	
	# Trigger climbing mechanics. Cehck for climbable surfaces colliding with us, and do climbing
	if Input.is_action_just_pressed("ui_end"):
		# If already climbing, make it leave climbing (unclimb)
		if is_climbing:
			ungrab_rope()
			return
		# Else check for nearby rope and grab it (start climbing)
		if not is_climbing:
			grab_rope()
		
	# While climbing, listen to user actions and move up or down and play animation
	if is_climbing:
		velocity = Vector2(0, 0) # Reset velocity
		$AnimatedSprite2D.animation = "climb"
		if Input.is_action_pressed("ui_up"):
			$AnimatedSprite2D.play("climb")
			velocity.y -= 8000 * delta # Main part
		elif Input.is_action_pressed("ui_down"):
			$AnimatedSprite2D.play("climb")
			velocity.y += 8000 * delta # Main part
		else:
			$AnimatedSprite2D.stop()

	# Move and Slide
	move_and_slide()

func _on_animated_sprite_2d_animation_finished():
	if is_attacking:
		is_attacking = false

func _on_animated_sprite_2d_animation_looped():
	if is_attacking:
		is_attacking = false





# Grabs the rope object whose area are we overlapping with
func grab_rope():
	for rope in get_tree().get_nodes_in_group("ropes"):
		if rope.is_player_touching_the_rope:
			is_climbing = true
			position.x = rope.position.x


# Player no longer climbing, and gives a slight jump boost
func ungrab_rope():
	is_climbing = false
	velocity.y = jump_speed
	jumps_used = 0
	is_jumping = true
