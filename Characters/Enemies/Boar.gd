extends CharacterBody2D


@export var floor_raycast: RayCast2D
@export var gravity:float = 100



func _physics_process(delta:float) -> void:
	$AnimatedSprite2D.play("idle")


