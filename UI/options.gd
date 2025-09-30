extends Control

@onready var master_slide = $CenterContainer/VBoxContainer/MasterSlide
@onready var sfx_slide = $CenterContainer/VBoxContainer/SFXSlide
@onready var music_slide = $CenterContainer/VBoxContainer/MusicSlide

var change_image = 0.3
const CHANGE_IMAGE_MAX = 0.3
var image = 0
	
func _ready():
	master_slide.value=AudioServer.get_bus_volume_db(0)
	sfx_slide.value=AudioServer.get_bus_volume_db(1)
	music_slide.value=AudioServer.get_bus_volume_db(2)

func _on_button_pressed():
	get_tree().change_scene_to_file("res://UI/StartMenu.tscn")

func _on_master_slide_value_changed(value):
	if value == master_slide.min_value:
		AudioServer.set_bus_mute(0, true)
	else:
		AudioServer.set_bus_mute(0, false)
	AudioServer.set_bus_volume_db(0, value)


func _on_sfx_slide_value_changed(value):
	if value == sfx_slide.min_value:
		AudioServer.set_bus_mute(2, true)
	else:
		AudioServer.set_bus_mute(2, false)
	AudioServer.set_bus_volume_db(2, value)


func _on_sfx_slide_drag_ended(_value_changed):
	SoundManager.start_round_end()

func _on_music_slide_value_changed(value):
	if value == music_slide.min_value:
		AudioServer.set_bus_mute(1, true)
	else:
		AudioServer.set_bus_mute(1, false)
	AudioServer.set_bus_volume_db(1, value)
