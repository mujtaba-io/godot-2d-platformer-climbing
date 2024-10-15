
extends CharacterBody2D

# Variables to control movement
var base_speed = 64
var patrol_distance = 200
var direction = 1
var start_position
@export var horizontal_motion: bool = true

# Timer to control direction change
var time_to_change = 1.0 # Time in seconds to change direction
var timer = 0.0

func _ready():
	# Store the starting position of the bird
	start_position = global_position

func _process(delta):
	# Move the bird left and right
	patrol(delta)

func patrol(delta):
	# Increment the timer
	timer += delta
	
	# Change direction if timer exceeds the time to change direction
	if timer >= time_to_change:
		direction *= -1 # Reverse direction
		timer = 0.0 # Reset timer

	# Calculate movement direction and move the bird
	if horizontal_motion:
		velocity = Vector2(direction * base_speed, 0)
	else:
		velocity = Vector2(0, direction * base_speed)
	move_and_slide()

	# Limit the movement range based on patrol_distance
	if abs(global_position.x - start_position.x) > patrol_distance:
		# Snap back to the patrol distance limit and reverse direction
		global_position.x = start_position.x + sign(direction) * patrol_distance
		direction *= -1  # Reverse direction immediately when hitting the limit
		timer = 0.0      # Reset timer
	
	
		# Flip the sprite based on direction of movement
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	
	# Play animation
	$AnimatedSprite2D.play("fly")
	
	impact_on_player_touch()


func _on_verticle_sensors_body_entered(body):
	if body in get_tree().get_nodes_in_group("players"):
		self.queue_free()
		# Give player a jump boost
		body.velocity.y = body.jump_speed

func impact_on_player_touch():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider in get_tree().get_nodes_in_group("players"):
			if "health" in collider:
				collider.health -= 1
