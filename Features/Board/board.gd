extends Node3D

@export var width: int = 8
@export var height: int = 8
@export var wall_count: Count
@export var food_count: Count

@export var exit: PackedScene
@export var wall_tiles: Array[PackedScene] = []
@export var floor_tiles: Array[PackedScene] = []
@export var enemy_tiles: Array[PackedScene] = []
@export var outer_wall_tiles: Array[PackedScene] = []
@export var food_tiles: Array[PackedScene] = []

var grid_positions: Array[Vector3] = []
var rotations: Array[float] = [0, 90, 180, 270]

enum OuterWall { EMPTY, CORNER, WALL_X, WALL_Y }


func _ready() -> void:
	randomize()


func initialise_list() -> void:
	grid_positions.clear()
	for x in range(width):
		for y in range(height):
			if x == 0 or x == width - 1 or y == 0 or y == height - 1:
				continue
			grid_positions.append(Vector3(x, 0, y))


func board_setup() -> void:
	for child in get_children():
		child.queue_free()

	for x in range(-1, width + 1):
		for y in range(-1, height + 1):
			var tile: PackedScene = floor_tiles[randi() % floor_tiles.size()]
			if x == -1 and y == -1:
				tile = outer_wall_tiles[OuterWall.CORNER]
			elif x == -1 and y != height:
				tile = outer_wall_tiles[OuterWall.WALL_X]
			elif y == -1 and x != width:
				tile = outer_wall_tiles[OuterWall.WALL_Y]
			elif x == width or y == height:
				tile = outer_wall_tiles[OuterWall.EMPTY]
			var instantiate: Node3D = tile.instantiate()
			add_child(instantiate)
			instantiate.position = Vector3(x, 0, y)


func random_position() -> Vector3:
	var random_index: int = randi() % grid_positions.size()
	var grid_position: Vector3 = grid_positions[random_index]
	grid_positions.remove_at(random_index)
	return grid_position


func layout_object_at_random(
	tile_array: Array[PackedScene], minimum: int, maximum: int, with_rotation: bool = false
) -> void:
	if tile_array.size() == 0:
		return
	var object_count: int = randi() % (maximum - minimum + 1) + minimum
	for _n in range(object_count):
		var spawn_position: Vector3 = random_position()
		var tile_choice: PackedScene = tile_array[randi() % tile_array.size()]
		var instance: Node3D = tile_choice.instantiate()
		add_child(instance)
		instance.position = spawn_position
		instance.rotation_degrees = (
			Vector3(0, rotations[randi() % rotations.size()], 0) if with_rotation else Vector3.ZERO
		)


func configure_scene(level: int) -> void:
	board_setup()

	initialise_list()

	layout_object_at_random(wall_tiles, wall_count.minimum, wall_count.maximum, true)
	layout_object_at_random(food_tiles, food_count.minimum, food_count.maximum)

	var enemy_count: int = int(log(level) / log(2))

	layout_object_at_random(enemy_tiles, enemy_count, enemy_count)

	var exit_instantiate: Node3D = exit.instantiate()
	add_child(exit_instantiate)
	exit_instantiate.position = Vector3(width - 1, 0, 0)
