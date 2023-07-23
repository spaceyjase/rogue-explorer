extends CanvasLayer

var _food_label: Label
var _day_label: Label


func _ready() -> void:
	_food_label = $MarginContainer/FoodLabel
	_day_label = $MarginContainer/DayLabel
	$MessageTimer.timeout.connect(clear_message)


func clear_message() -> void:
	$MessageLabel.text = String()
	$MessageLabel.hide()


func show_message(message: String) -> void:
	if message.is_empty():
		clear_message()
		return

	$MessageLabel.text = message
	$MessageLabel.show()
	$MessageTimer.start()


func _on_start_button_pressed() -> void:
	$Panel.visible = false
	$Title.visible = false
	$StartButton.visible = false


func _on_player_food_changed(food) -> void:
	_food_label.text = "Food: " + str(food)


func _on_game_manager_level_changed(level) -> void:
	_day_label.text = "Day: " + str(level)


func _on_game_manager_game_over(_day) -> void:
	$Panel.visible = true
	$MessageLabel.text = "You survived " + str(_day) + (" day!" if _day == 1 else " days!")
	$MessageLabel.show()
