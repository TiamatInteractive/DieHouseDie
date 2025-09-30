extends Label

@export var time := 0.3
@onready var timer: Timer = $Timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = time
	timer.start()

func _on_timer_timeout() -> void:
	queue_free()
