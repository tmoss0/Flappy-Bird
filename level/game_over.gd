extends CanvasLayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	$Panel/ButtonRestart.pressed.connect(_on_restart_pressed)
	$Panel/ButtonQuit.pressed.connect(_on_quit_pressed)
	hide_for_play()

func hide_for_play() -> void:
	visible = false

func show_game_over(final_score: int = 0) -> void:
	$Panel/LabelFinalScore.text = "Score: %d" % final_score
	visible = true

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().quit()
