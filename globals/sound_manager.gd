extends Node

@onready var step: AudioStreamPlayer = $Step
@onready var kill: AudioStreamPlayer = $Kill
@onready var round_start: AudioStreamPlayer = $RoundStart
@onready var round_end: AudioStreamPlayer = $RoundEnd
@onready var death: AudioStreamPlayer = $Death
@onready var critical_kill: AudioStreamPlayer = $Critical_Kill
@onready var game_overASP: AudioStreamPlayer = $Game_Over
@onready var time_bonus: AudioStreamPlayer = $Time_bonus

signal round_over
signal game_over
signal start_round

func start_step():
	step.play()

func start_kill():
	kill.play()
	
func start_critical_kill():
	critical_kill.play()

func start_round_start():
	MusicManager.stop_music()
	round_start.play()
	
func start_round_end():
	round_end.play()

func start_death():
	death.play()

func start_game_over():
	game_overASP.play()

func _on_round_start_finished() -> void:
	MusicManager.start_second_fase_music()
	start_round.emit()

func start_time_bonus():
	time_bonus.play()
	
func stop_time_bonus():
	time_bonus.stop()
	
func _on_game_over_finished() -> void:
	game_over.emit()


func _on_round_end_finished() -> void:
	round_over.emit()
