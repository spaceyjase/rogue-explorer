extends Area3D


func _on_area_entered(_area: Area3D) -> void:
	EventBus.level_complete.emit()
