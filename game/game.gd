extends Node2D

const TIMED_LABEL = preload("uid://dm8gnfhkkb74q")
const ENEMY = preload("uid://dj4jgin2rn0e1")

var board = []
@onready var enemies: Node = $Enemies
@onready var player: Node2D = $Player

var levels = [
	{
		"enemies":[{"id":2, "height":Vector2i(2,6)},
		{"id":1, "height":Vector2i(6,2)}]
	},
	{
		"enemies":[{"id":3, "height":Vector2i(5,1)},
		{"id":3, "height":Vector2i(1,5)},
		{"id":3, "height":Vector2i(7,1)},
		{"id":3, "height":Vector2i(1,7)}]
	},
	{
		"enemies":[
		{"id":0, "height":Vector2i(4,2)},
		{"id":0, "height":Vector2i(2,4)}]
	},
	{
		"enemies":[{"id":4, "height":Vector2i(7,1)},
		{"id":4, "height":Vector2i(1,7)},]
	},
	{
		"enemies":[{"id":2, "height":Vector2i(2,6)},
		{"id":1, "height":Vector2i(6,2)},
		{"id":2, "height":Vector2i(3,5)},
		{"id":1, "height":Vector2i(5,3)}]
	},
	{
		"enemies":[{"id":2, "height":Vector2i(1,7)},
		{"id":1, "height":Vector2i(7,1)},
		{"id":0, "height":Vector2i(3,3)},
		{"id":4, "height":Vector2i(4,4)}]
	},
	{
		"enemies":[
		{"id":4, "height":Vector2i(3,3)},
		{"id":4, "height":Vector2i(4,4)},
		{"id":3, "height":Vector2i(5,1)},
		{"id":3, "height":Vector2i(1,5)},
		{"id":3, "height":Vector2i(7,1)},
		{"id":3, "height":Vector2i(1,7)}]
	},
	{
		"enemies":[
		{"id":0, "height":Vector2i(3,3)},
		{"id":0, "height":Vector2i(4,4)},
		{"id":0, "height":Vector2i(3,4)},
		{"id":0, "height":Vector2i(4,3)}]
	},
	{
		"enemies":[
		{"id":0, "height":Vector2i(3,3)},
		{"id":4, "height":Vector2i(4,4)},
		{"id":0, "height":Vector2i(3,4)},
		{"id":4, "height":Vector2i(4,3)},
		{"id":3, "height":Vector2i(5,1)},
		{"id":3, "height":Vector2i(1,5)},
		{"id":1, "height":Vector2i(7,1)},
		{"id":2, "height":Vector2i(1,7)}]
	},
	
]

var time_left = 60
var ending = false

@onready var base_2d: Sprite2D = $Base2D
@onready var up_2d: Sprite2D = $Up2D
@onready var left_2d: Sprite2D = $Left2D
@onready var down_2d: Sprite2D = $Down2D
@onready var right_2d: Sprite2D = $Right2D
@onready var round_timer: Timer = $RoundTimer
@onready var time_number_label: Label = $TimeNumberLabel
@onready var score_label: Label = $ScoreLabel
@onready var life_sprite_2d_2: Sprite2D = $LifeSprite2D2
@onready var life_sprite_2d_1: Sprite2D = $LifeSprite2D1
@onready var life_sprite_2d_3: Sprite2D = $LifeSprite2D3
@onready var round_number_label: Label = $RoundNumberLabel

var scores_screen = []
var enemies_q = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicManager.start_music()
	populate_map()
	generate_enemmies()
	enemies_q = enemies.get_children().size()
	connect_ennemies()
	connect_player()
	change_map()
	GameInfo.added_points.connect(added_points)
	if GameInfo.actual_lifes >0:
		life_sprite_2d_1.show()
	if GameInfo.actual_lifes >1:
		life_sprite_2d_2.show()
	if GameInfo.actual_lifes >2:
		life_sprite_2d_3.show()
	SoundManager.start_round.connect(start_round)
	SoundManager.round_over.connect(round_over)
	round_number_label.text = str(GameInfo.actual_round)

func populate_map() -> void:
	for i in range(GameInfo.board_size):
		board.append([])
		for J in range(GameInfo.board_size):
			board[i].append(null)

func connect_ennemies() -> void:
	for enemy in enemies.get_children():
		enemy._on_movement.connect(_on_movement)
		enemy.verify = verify
		enemy.on_death.connect(enemy_on_death)
		board[enemy.height.x-1][enemy.height.y-1] = enemy

func generate_enemmies() -> void:
	var enemies_to_spawm = []
	if GameInfo.spawner:
		enemies_to_spawm = GameInfo.spawner
	elif !levels.size() < GameInfo.actual_round:
		enemies_to_spawm = levels[GameInfo.actual_round-1]["enemies"]
	else:
		var difficult := float(GameInfo.actual_round)
		var proto_board = []
		for i in range(GameInfo.board_size):
			proto_board.append([])
			for j in range(GameInfo.board_size):
				proto_board[i].append(i+j < 3)
		
		while difficult > 1 and enemies_to_spawm.size() < 21:
			var height = Vector2i(randi() % GameInfo.board_size + 1, randi() % GameInfo.board_size + 1)
			while proto_board[height.x-1][height.y-1] or GameInfo.verify_fall(height):
				height = Vector2i(randi() % GameInfo.board_size + 1, randi() % GameInfo.board_size + 1)
			var id = randi() % 5
			while !can_generate(id,height):
				id = randi() % 5
			enemies_to_spawm.append({"id":id, "height": height})
			proto_board[height.x-1][height.y-1] = true
			difficult -= 1
			if id == 0 || id == 4:
				difficult -= 0.5
	
	GameInfo.spawner = enemies_to_spawm 
	for enemy in enemies_to_spawm:
		var new_enemy = ENEMY.instantiate()
		new_enemy.height = enemy.height
		new_enemy.id = enemy.id
		enemies.add_child(new_enemy)

func can_generate(id, height) -> bool:
	if id == 1 and height.y > height.x:
		return false
	if id == 2 and height.x > height.y:
		return false
	if id == 3 and height.x + height.y<=4:
		return false
	if id == 0 or id == 4:
		return randi()%2 < 1
	return true

func enemy_on_death():
	enemies_q -= 1
	if enemies_q <= 0:
		_end_round()

func connect_player() -> void:
	board[0][0] = player

func verify(height:Vector2i) -> bool:
	if board[height.x-1][height.y-1]:
		return board[height.x-1][height.y-1].is_player()
	return true

func added_points(points:int, height: Vector2i):
	var new_label = TIMED_LABEL.instantiate()
	new_label.text = str(points)
	new_label.position = GameInfo.get_pixel_by_height(height) + Vector2(-5,-103)
	add_child(new_label)

func _on_movement(old_id: Vector2i, new_id: Vector2i, damage: int, direction: int, selfie) -> void:
	if GameInfo.verify_fall(new_id):
		return
	change_map()
	var new_space = board[new_id.x-1][new_id.y-1]
	var old_space = board[old_id.x-1][old_id.y-1]
	if !old_space:
		old_space = selfie
		board[old_id.x-1][old_id.y-1] = selfie
	if new_space and old_space:
		battle(old_space, new_space,damage, direction)
	board[old_id.x-1][old_id.y-1] = null
	board[new_id.x-1][new_id.y-1] = old_space

func battle(old_space, new_space, damage, direction):
	if new_space.has_method("is_killing"):
		if new_space.is_killing() and !damage == 6 and !damage == 1:
			old_space.death()
			return
	if damage > 1:
		if damage == 6:
			new_space.death_crit()
		else:
			new_space.death()
		return
	new_space.move(direction)

func _on_player_player_dead() -> void:
	GameInfo.actual_lifes -= 1
	if GameInfo.actual_lifes <= 0:
		get_tree().change_scene_to_file("res://UI/DeathUI.tscn")
		return
	get_tree().reload_current_scene()

func change_map() -> void:
	var dice = player.dice
	base_2d.frame = dice[0]-1
	up_2d.frame = dice[3]-1
	left_2d.frame = dice[1]-1
	down_2d.frame = dice[4]-1
	right_2d.frame = dice[2]-1

func _on_start_timer_timeout() -> void:
	SoundManager.start_round_start()

func start_round():
	round_timer.start()
	player.stop = false
	for enemy in enemies.get_children():
		enemy.stop = false

func round_over():
	await get_tree().create_timer(0.2).timeout
	get_tree().reload_current_scene()


func _process(_delta: float) -> void:
	if ending:
		return
	time_left = round_timer.time_left
	change_point()

func change_point(is_zero = false):
	if time_left >= 60 or (time_left == 0 and !is_zero):
		time_number_label.text = "1:00"
	else:
		var base = "0:"
		if time_left < 10:
			base += "0"
		time_number_label.text = base+str(int(time_left))
	score_label.text = GameInfo.get_score_str()

func _end_round():
	ending = true
	MusicManager.stop_music()
	SoundManager.start_time_bonus()
	player.stop = true
	round_timer.paused = true
	time_left = int(round_timer.time_left)
	for i in range(time_left):
		time_left -= 1
		GameInfo.actual_score += GameInfo.get_kill_point(GameInfo.actual_round)/10
		change_point(true)
		await get_tree().create_timer(0.02).timeout
	GameInfo.actual_round += 1
	GameInfo.spawner = null
	SoundManager.stop_time_bonus()
	await get_tree().create_timer(0.02).timeout
	SoundManager.start_round_end()

func _on_round_timer_timeout() -> void:
	_on_player_player_dead()
