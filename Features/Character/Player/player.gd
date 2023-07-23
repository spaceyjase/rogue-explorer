extends "res://Features/Character/character_base.gd"

signal moved
signal dead
signal food_changed(food: int)

var _food: int = 0:
	get:
		return _food
	set(value):
		_food = value
		if _food <= 0:
			_food = 0
			_dead = true
		food_changed.emit(_food)

var _dead: bool = false:
	get:
		return _dead
	set(value):
		if not _dead and value:
			dead.emit()
			$DeadAudioStreamPlayer.play()
		_dead = value

var _start_position: Vector3 = Vector3()


func configure(food: int) -> void:
	_food = food


func _ready() -> void:
	_start_position = global_position


func _process(_delta: float) -> void:
	if not active:
		return
	if _dead:
		return
	if can_move:
		for direction in moves.keys():
			if Input.is_action_just_pressed(direction):
				_food -= 1
				move(direction)
				moved.emit()


func reset() -> void:
	global_position = _start_position
	$RayCasts.global_rotation = _raycast_default


func collide_with(direction: String, object: Node) -> void:
	if object.is_in_group("wall"):
		attack(direction)
		object.damage(1)


func damage(amount: int) -> void:
	_food -= amount
	if not _dead:
		$HurtAudioStreamPlayer.play()


func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("food"):
		_food += area.value
