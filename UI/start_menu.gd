extends Control

func _ready() -> void:
	MusicManager.start_music_menu()

func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/credts_ui.tscn")


func _on_start_button_pressed() -> void:
	GameInfo.start_game()
	get_tree().change_scene_to_file("res://game/game.tscn")


func _on_score_button_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/DeathUI.tscn")


func _on_htp_button_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/how_to_play.tscn")


func _on_options_button_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/options.tscn")
