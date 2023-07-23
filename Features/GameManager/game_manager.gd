extends Node3D

signal level_changed(level: int)
signal game_over(day: int)

@export var settings: GameSettings

enum State {
	None,
	Menu,
	PlayerTurn,
	EnemyTurn,
	MovingEnemies,
	LevelComplete,
	GameOver,
}

var _state: State = State.None
var _level: int = 1:
	get:
		return _level
	set(value):
		_level = value
		level_changed.emit(_level)


func _ready() -> void:
	$Board.configure_scene(_level)
	_configure_player()
	_configure_events()
	_change_state(State.Menu)


func _configure_player() -> void:
	$Player.configure(settings.food)
	$Player.dead.connect(_on_player_dead)


func _configure_events() -> void:
	$AnimationPlayer.animation_finished.connect(_on_animation_finished)
	EventBus.level_complete.connect(_on_level_complete)


func _process(_delta: float) -> void:
	if _state == State.GameOver:
		return

	match _state:
		State.None:
			return
		State.Menu:
			return
		State.PlayerTurn:
			await $Player.moved
			if not _state == State.GameOver:
				_change_state(State.EnemyTurn)
		State.EnemyTurn:
			_move_enemies()
			_change_state(State.MovingEnemies)
		State.MovingEnemies:
			pass
		State.LevelComplete:
			pass
		State.GameOver:
			pass


func _move_enemies() -> void:
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if _state == State.GameOver:
			return
		enemy.move_enemy()
		await get_tree().create_timer(settings.move_delay).timeout

	_change_state(State.PlayerTurn)


func _change_state(new_state: State) -> void:
	if new_state == _state:
		return

	match new_state:
		State.None:
			return
		State.Menu:
			$Player.active = false
			pass
		State.PlayerTurn:
			$Player.active = true
		State.EnemyTurn:
			$Player.active = false
		State.MovingEnemies:
			pass
		State.LevelComplete:
			pass
		State.GameOver:
			game_over.emit(_level)
			await get_tree().create_timer(settings.restart_time).timeout
			get_tree().reload_current_scene()
	_state = new_state
	await get_tree().process_frame


func _on_player_dead():
	_change_state(State.GameOver)


func _on_level_complete():
	_state = State.LevelComplete
	$AnimationPlayer.play("level_complete")


func _on_animation_finished(animation_name: String) -> void:
	if animation_name == "level_complete":
		_level += 1
		$Board.configure_scene(_level)
		$Player.reset()
		_change_state(State.PlayerTurn)


func _on_start_button_pressed() -> void:
	_change_state(State.PlayerTurn)
