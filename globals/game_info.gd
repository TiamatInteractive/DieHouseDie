extends Node

var distance := [Vector2(-16,-25), Vector2(16,25), Vector2(16,-25), Vector2(-16,25)]
var board_size := 7
var lifes := 3
var actual_lifes := 3
var actual_score := 0
var actual_round := 1:
	set(value):
		actual_round = value
		if value == 5:
			actual_difficult = 2
		if value == 10:
			actual_difficult = 3
		if value == 15:
			actual_difficult = 4
		if value == 20:
			actual_difficult = 5

var spawner = null
var actual_difficult := 1
var saved_score := true
var player_height := Vector2i(1,1)

signal critical
signal added_points(points:int, height: Vector2i)

func verify_fall(height: Vector2i) -> bool:
	return height.x <= 0 || height.y <= 0 || height.x+height.y > board_size+1

func add_height_by_direction(height: Vector2i, direction: int) -> Vector2i:
	match direction:
		0:
			height.x -= 1
		1:
			height.x += 1
		2:
			height.y -= 1
		3:
			height.y += 1
	return height

func verify_fall_by_movement(height: Vector2i, direction: int) -> bool:
	return verify_fall(add_height_by_direction(height,direction))

func start_game():
	actual_lifes = lifes
	actual_score = 0
	actual_round = 10
	actual_difficult = 3
	saved_score = false
	spawner = null

func add_point_kill(height: Vector2i):
	add_points(get_kill_point(actual_round),height)

func add_point_critical(height: Vector2i):
	critical.emit()
	add_points(get_kill_point(actual_round)*10, height)

func add_points(points: int, height: Vector2i):
	actual_score += points
	added_points.emit(points, height)

func get_kill_point(x: int):
	if x <= 0:
		return 0
	return 100*x + get_kill_point(x-1)

func get_pixel_by_height(height:Vector2i):
	return distance[1] * (height.x-1) + distance[3] * (height.y-1)

func get_score_str():
	return get_str_by_score(actual_score)

func get_str_by_score(value:int):
	var score_text = ""
	var aux = 1
	for i in range(8):
		if value < aux:
			score_text+="0"
		aux*=10
	if value > 0:
		score_text += str(value)
	return score_text
	
