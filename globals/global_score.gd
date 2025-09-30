extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SilentWolf.configure({
	"api_key": "0S7AY5BNpN2bF87ALQmfqDgPp1imin5qFoaZ3Dj0",
	"game_id": "dice",
	"log_level": 1
	})

	SilentWolf.configure_scores({
	"open_scene_on_close": "res://scenes/MainPage.tscn"
	})

func save_score(player_name, score) -> void:
	await SilentWolf.Scores.save_score(player_name, score).sw_save_score_complete

func get_scores() -> Dictionary:
	var sw_result: Dictionary = await SilentWolf.Scores.get_scores(5).sw_get_scores_complete
	return sw_result
