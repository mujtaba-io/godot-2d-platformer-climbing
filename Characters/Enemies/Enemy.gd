extends CharacterBody2D


@export var floor_raycast: RayCast2D
@export var gravity:float = 100

var vel:Vector2
var speed = 40

func _ready():
	vel.x = -speed

func _physics_process(delta:float) -> void:
	if not is_on_floor(): vel.y += gravity * delta
	vel.y = clamp(vel.y, 0, 98)
	if is_on_wall() or (is_on_floor() and not floor_raycast.is_colliding()):
		print("t")
		vel.x = vel.x * -1
		floor_raycast.position.x *= -1.0
		$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h
	
	velocity = vel
	move_and_slide()
	
	$AnimatedSprite2D.play("walk")
	
	print(vel)



func _on_verticle_sensors_body_entered(body):
	if body in get_tree().get_nodes_in_group("players"):
		self.queue_free()
		# Give player a jump boost
		body.velocity.y = body.jump_speed


func _on_horizontal_sensors_body_entered(body):
	if body in get_tree().get_nodes_in_group("players"):
		if "health" in body:
			body.health -= 1
