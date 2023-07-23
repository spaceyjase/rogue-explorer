extends Area3D

var _health: int = 0
var _animation_player: AnimationPlayer


func _ready() -> void:
	_health = randi_range(1, 3)
	_animation_player = $AnimationPlayer


func damage(amount: int) -> void:
	_health -= amount
	_animation_player.play("damage")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "damage" and _health <= 0:
		queue_free()
