extends Area3D

@export var speed: float = 5
@export var rotate_speed: float = 0.2

var active: bool = true

var can_move: bool = true
var moves: Dictionary = {
	"north": Vector3(0, 0, -1),
	"south": Vector3(0, 0, 1),
	"east": Vector3(1, 0, 0),
	"west": Vector3(-1, 0, 0)
}

var _move_tween: Tween
var _raycast_default: Vector3
var _facing: String = "north"
var _attack_speed: float = speed * 2

@onready var raycasts: Dictionary = {
	"north": $RayCasts/Forward,
	"south": $RayCasts/Back,
	"east": $RayCasts/Right,
	"west": $RayCasts/Left
}


func _ready() -> void:
	_raycast_default = $RayCasts.global_rotation


func collide_with(_direction: String, _object: Node) -> void:
	pass


func move(direction: String) -> void:
	if raycasts[direction].is_colliding():
		collide_with(direction, raycasts[direction].get_collider())
		return
	can_move = false
	if _move_tween:
		_move_tween.stop()
	_move_tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	_move_tween.tween_property(
		self,
		"transform",
		transform.looking_at(position + moves[direction]),
		rotate_speed if _facing != direction else 0.0
	)
	_move_tween.chain().tween_property(self, "position", position + moves[direction], 1.0 / speed)
	_move_tween.tween_callback(_move_tweener_finished)
	$AudioStreamPlayer.play()


func _move_tweener_finished() -> void:
	$RayCasts.global_rotation = _raycast_default
	can_move = true


func attack(direction: String) -> void:
	can_move = false
	if _move_tween:
		_move_tween.stop()
	_move_tween = create_tween().set_trans(Tween.TRANS_SPRING)
	_move_tween.tween_property(
		self,
		"transform",
		transform.looking_at(position + moves[direction]),
		rotate_speed if _facing != direction else 0.0
	)
	var start_position: Vector3 = position
	_move_tween.chain().tween_property(
		self, "position", position + moves[direction], 1.0 / _attack_speed
	)
	_move_tween.chain().tween_property(self, "position", start_position, 1.0 / _attack_speed)
	_move_tween.tween_callback(_move_tweener_finished)
