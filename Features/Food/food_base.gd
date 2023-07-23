extends Area3D

@export var value: int = 0


func _ready() -> void:
	$MeshParent.get_children()[randi_range(1, $MeshParent.get_child_count()) - 1].visible = true
	$AnimationPlayer.speed_scale = randf_range(-1, 1)


func _on_area_entered(_area: Area3D) -> void:
	$AnimationPlayer.speed_scale = 1
	$AnimationPlayer.play("pickup")
