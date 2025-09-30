extends Node

@onready var game_theme: AudioStreamPlayer = $GameTheme
@onready var menu_theme: AudioStreamPlayer = $MenuTheme

func start_second_fase_music():
	game_theme.play(7)
	menu_theme.stop()

func stop_music():
	game_theme.stop() 

func start_music():
	game_theme.play()
	menu_theme.stop()

func start_music_menu():
	if !menu_theme.playing:
		menu_theme.play()
	game_theme.stop() 
