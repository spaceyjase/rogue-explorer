extends "res://Features/Character/character_base.gd"

@export var damage: int = 1

var player: Node


func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")[0]


func move_enemy() -> void:
	var direction: String

	# this makes the game a little more difficult, as an enemy will typically ALWAYS block the player; frustrating
	#for ray in raycasts:
	#	var _ray = raycasts[ray]
	#	if (
	#		_ray.is_colliding()
	#		and _ray.get_collider() != null
	#		and _ray.get_collider().is_in_group("player")
	#	):
	#		direction = ray
	#		break

	if len(direction) == 0:
		if is_equal_approx(player.global_position.x, global_position.x):
			direction = "south" if player.global_position.z > global_position.z else "north"
		else:
			direction = "east" if player.global_position.x > global_position.x else "west"
	move(direction)


func collide_with(direction: String, object: Node) -> void:
	if object.is_in_group("wall") or object.is_in_group("player"):
		attack(direction)
		object.damage(damage)
