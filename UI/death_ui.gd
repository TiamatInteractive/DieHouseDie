extends Control
@onready var label: Label = $Label
const PLAYER_SCORE_UI = preload("uid://d4yejg6upj60")
@onready var button: Button = $Button
@onready var score_label: Label = $ScoreLabel
@onready var score: Control = $Score
@onready var name_label: Label = $NameLabel2
@onready var text_edit: LineEdit = $TextEdit

func _ready() -> void:
	if GameInfo.saved_score:
		label.hide()
		button.show()
		score.show()
		name_label.hide()
		score_label.show()
		text_edit.hide()
	else:
		label.show()
		score.hide()
		name_label.hide()
		score_label.hide()
		button.hide()
		text_edit.hide()
		score_label.text = GameInfo.get_score_str()
		MusicManager.stop_music()
		SoundManager.game_over.connect(game_over)
		SoundManager.start_game_over()

func game_over() -> void:
	label.hide()
	button.show()
	score.show()
	name_label.show()
	score_label.show()
	text_edit.show()
	MusicManager.start_music_menu()

func _on_button_pressed() -> void:
	GameInfo.saved_score = true
	get_tree().change_scene_to_file("res://UI/StartMenu.tscn")

func _on_text_edit_text_submitted(new_text: String) -> void:
	if !GameInfo.saved_score:
		GlobalScore.save_score(new_text.to_upper(), GameInfo.actual_score)
	GameInfo.saved_score = true
	get_tree().reload_current_scene()
