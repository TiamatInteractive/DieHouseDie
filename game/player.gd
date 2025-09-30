extends Node2D


const SPEED = 300.0
var height := Vector2i(1,1)
var can_move = 10
var stop = true
@onready var move_timer: Timer = $MoveTimer
@onready var critical_label: Label = $CriticalLabel
var new_position := position

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var sprite_2d_2: Sprite2D = $Sprite2D2
@onready var sprite_2d_3: Sprite2D = $Sprite2D3
@onready var critical_timer: Timer = $CriticalTimer

signal player_dead
signal _on_movement(old_id:Vector2i, new_id:Vector2i, damage:int, direction:int, selfi)

var dice = [1,2,5,3,4,6]

func _ready() -> void:
	change_sprite()
	GameInfo.critical.connect(critical)
	new_position = position
			

func critical():
	critical_label.show()
	critical_timer.start()

func _process(delta: float) -> void:
	position += (new_position- position)*delta*10
	if can_move and !stop:
		move()

func move()->void:
	var old_id := height
	var direction_press := get_direction()
	height = GameInfo.add_height_by_direction(height, direction_press)
	GameInfo.player_height = height
	if direction_press != -1:
		can_move = false
		move_timer.start()
		new_position += GameInfo.distance[direction_press]
		verify_death()
		var down_direction := rotate_dice(direction_press)
		change_sprite()
		SoundManager.start_step()
		_on_movement.emit(old_id, height, down_direction, direction_press, self)

func get_direction() -> int:
	if Input.is_action_just_pressed("ui_left"):
		return 0
	if Input.is_action_just_pressed("ui_right"):
		return 1
	if Input.is_action_just_pressed("ui_up"):
		return 2
	if Input.is_action_just_pressed("ui_down"):
		return 3
	return -1

func _on_move_timer_timeout() -> void:
	can_move = true

func verify_death() -> void:
	if GameInfo.verify_fall(height):
		death()

func rotate_dice(direction) -> int:
	match direction:
		0:
			var aux = dice[0]
			dice[0] = dice[1]
			dice[1] = dice[5]
			dice[5] = dice[2]
			dice[2] = aux
		1:
			var aux = dice[0]
			dice[0] = dice[2]
			dice[2] = dice[5]
			dice[5] = dice[1]
			dice[1] = aux
		2:
			var aux = dice[0]
			dice[0] = dice[3]
			dice[3] = dice[5]
			dice[5] = dice[4]
			dice[4] = aux
		3:
			var aux = dice[0]
			dice[0] = dice[4]
			dice[4] = dice[5]
			dice[5] = dice[3]
			dice[3] = aux
	return dice[0]

func death():
	player_dead.emit()
	queue_free()
	SoundManager.start_death()

func is_player():
	return true

func change_sprite():
	sprite_2d.frame_coords.x = get_value(5)
	sprite_2d_2.frame_coords.x = get_value(4)
	sprite_2d_3.frame_coords.x = get_value(2)

func get_value(id):
	var top = 5
	if id == 5:
		top = 2
	match dice[id]:
		1:
			return 0
		2:
			return get_two(dice[top]-1)
		3:
			return get_three(dice[top]-1)
		4:
			return 3
		5:
			return 4
		6:
			return get_six(dice[top]-1)
	return -1

func get_six(next:int) -> int:
	if next == 1 or next == 4:
		return 8
	return 5
	
func get_two(next:int) -> int:
	if next == 5 or next == 0:
		return 6
	return 1
	
func get_three(next:int) -> int:
	if next == 1 or next == 4:
		return 7
	return 2

func _on_critical_timer_timeout() -> void:
	critical_label.hide()
