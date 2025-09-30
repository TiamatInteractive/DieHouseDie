extends Node2D

@export var verify:Callable
signal _on_movement(old_id:Vector2i, new_id:Vector2i, damage:int, direction:int, selfi)
signal on_death
var last_movement := 1
var stop = true
var anim_const = 10
var new_position := position
var const_anim := 3

var is_side := 0
@export var height := Vector2i(1,1)
@export var id := 4
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

func _ready() -> void:
	animated_sprite_2d.play(enemy_dict[id]["key"]+"_default")
	position = GameInfo.get_pixel_by_height(height)  + Vector2(0,-92)
	new_position = position
	match GameInfo.actual_difficult:
		1:
			timer.wait_time = 1.0
		2:
			timer.wait_time = 0.7
		3:
			timer.wait_time = 0.5
		4:
			timer.wait_time = 0.3
		5:
			anim_const = 30
			timer.wait_time = 0.1

var enemy_dict := {
	0: {"key":"pi", "func":random_moves},
	1: {"key":"p", "func":left_right_move},
	2: {"key":"g", "func":up_down_move},
	3: {"key":"b", "func":triangle_moves},
	4: {"key":"y", "func":pursuit_moves},
}

func calc_next_move() -> int:
	return enemy_dict[id]["func"].call()

func up_down_move() -> int:
	var next_move = [2,3]
	if last_movement in next_move and  cal_verifies(GameInfo.add_height_by_direction(height, last_movement)):
		return last_movement
	next_move.shuffle()
	for move1 in next_move:
		if cal_verifies(GameInfo.add_height_by_direction(height, move1)):
			return move1
	return -1

func left_right_move() -> int:
	var next_move = [0,1]
	if last_movement in next_move and cal_verifies(GameInfo.add_height_by_direction(height, last_movement)):
		return last_movement
	
	next_move.shuffle()
	for move1 in next_move:
		if cal_verifies(GameInfo.add_height_by_direction(height, move1)):
			return move1
	return -1

func random_moves() -> int:
	var next_move = [0,1,2,3]
	next_move.shuffle()
	for move1 in next_move:
		if cal_verifies(GameInfo.add_height_by_direction(height, move1)):
			return move1
	return -1

func triangle_moves() -> int:
	var next_move = [0,1,2,3]
	next_move.shuffle()
	match last_movement:
		0:
			next_move = [3,1]
		1:
			next_move = [2,0]
		2:
			next_move = [1,3]
		3:
			next_move = [0,2]
	for move1 in next_move:
		if cal_verifies(GameInfo.add_height_by_direction(height, move1)):
			return move1
	return -1
	
func pursuit_moves() -> int:
	var next_move = []
	next_move.shuffle()
	if height.x < GameInfo.player_height.x:
		next_move.append(1)
	elif height.x > GameInfo.player_height.x:
		next_move.append(0)
	if height.y < GameInfo.player_height.y:
		next_move.append(3)
	elif height.y > GameInfo.player_height.y:
		next_move.append(2)
		
	for move1 in next_move:
		if cal_verifies(GameInfo.add_height_by_direction(height, move1)):
			return move1
	return -1
func cal_verifies(height_to_verify:Vector2i)->bool:
	return !GameInfo.verify_fall(height_to_verify) and verify.call(height_to_verify) 

func _on_timer_timeout() -> void:
	if stop:
		return
	move()

func move(direction: int = -1) -> void:
	timer.start()
	if direction == -1:
		last_movement = calc_next_move()
	else:
		last_movement = direction
	if last_movement == -1:
		return
	physically_move()

func physically_move() -> void:
	var new_height := GameInfo.add_height_by_direction(height,last_movement)
	if GameInfo.verify_fall(new_height):
		height = new_height
		death_crit()
		return
	_on_movement.emit(height,new_height,2, last_movement, self)
	new_position = new_position + GameInfo.distance[last_movement]
	height = new_height
	play_animation(last_movement)

func is_killing() -> bool:
	return is_side != 0
	
func death():
	GameInfo.add_point_kill(height)
	SoundManager.start_kill()
	queue_free()
	on_death.emit()

func death_crit():
	GameInfo.add_point_critical(height)
	SoundManager.start_critical_kill()
	queue_free()
	on_death.emit()

func is_player():
	return false

func play_animation(direction):
	var animation = enemy_dict[id]["key"]
	match direction:
		0:
			animation += "_l"
		1:
			animation += "_r"
		3:
			animation += "_d"
		2:
			animation += "_u"
	if is_side == 0:
		animation += "_flat_side"
		if direction < 2:
			is_side = 2
		else:
			is_side = 1
	else:
		animation += "_side_flat"
		is_side = 0
	animated_sprite_2d.play(animation, 1.4)

func _on_animated_sprite_2d_animation_finished() -> void:
	match is_side:
		0:
			animated_sprite_2d.play(enemy_dict[id]["key"]+"_default")
		1:
			animated_sprite_2d.play(enemy_dict[id]["key"]+"_default_side_1")
		2:
			animated_sprite_2d.play(enemy_dict[id]["key"]+"_default_side_0")

func _process(delta: float) -> void:
	position += (new_position- position)*delta*anim_const
