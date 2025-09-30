extends Control

class_name PlayerScoreUi

@export var player_name: String = "Name"
@export var player_score: String = "0"

@onready var name_label: Label = $HBoxContainer/NameLabel
@onready var score_label: Label = $HBoxContainer/ScoreLabel

func _ready() -> void:
	name_label.text = player_name
	score_label.text = player_score
