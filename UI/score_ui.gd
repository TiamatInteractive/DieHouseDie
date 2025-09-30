extends Control

var scores: Dictionary
const PLAYER_SCORE_UI = preload("uid://d4yejg6upj60")

@onready var score_label_1: Label = $ScoreLabel1
@onready var score_label_2: Label = $ScoreLabel2
@onready var score_label_3: Label = $ScoreLabel3
@onready var score_label_4: Label = $ScoreLabel4
@onready var score_label_5: Label = $ScoreLabel5
@onready var name_label_1: Label = $NameLabel1
@onready var name_label_2: Label = $NameLabel2
@onready var name_label_3: Label = $NameLabel3
@onready var name_label_4: Label = $NameLabel4
@onready var name_label_5: Label = $NameLabel5

func _ready() -> void:
	scores = await GlobalScore.get_scores()
	var cont = 0
	for score in scores.scores:
		match cont:
			0:
				score_label_1.text = GameInfo.get_str_by_score(score.score)
				name_label_1.text = score.player_name
			1:
				score_label_2.text = GameInfo.get_str_by_score(score.score)
				name_label_2.text = score.player_name
			2:
				score_label_3.text = GameInfo.get_str_by_score(score.score)
				name_label_3.text = score.player_name
			3:
				score_label_4.text = GameInfo.get_str_by_score(score.score)
				name_label_4.text = score.player_name
			4:
				score_label_5.text = GameInfo.get_str_by_score(score.score)
				name_label_5.text = score.player_name
		cont+= 1
