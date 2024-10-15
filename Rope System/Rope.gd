extends Area2D


var is_player_touching_the_rope: bool = false


func _ready():
	add_to_group("ropes")



func _on_body_entered(body):
	if body in get_tree().get_nodes_in_group("players"):
		is_player_touching_the_rope = true


func _on_body_exited(body):
	if body in get_tree().get_nodes_in_group("players"):
		is_player_touching_the_rope = false
