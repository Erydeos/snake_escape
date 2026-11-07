extends CanvasLayer

signal start_signal
signal update_score(time: float, time_step: float)

var time: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ScoreTimer.stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_start_button_pressed() -> void:
	start_signal.emit()
	time = 0

func toggle_visibility() -> void:
	$StartButton.visible = not $StartButton.visible
	if $ScoreTimer.is_stopped():
		$ScoreTimer.start()
	else:
		$ScoreTimer.stop()

func _on_score_timer_timeout() -> void:
	time = snappedf(time + $ScoreTimer.wait_time, 0.1)
	update_score.emit(time, $ScoreTimer.wait_time)
	
func print_score(mod: String, total_score: float):
	$ScoreLabel.text = "Total Score: " + str(total_score) + "\n" + mod

func scale_hud(window: Vector2i):
	var scale_mod = float(window.x) / float(640)
	$StartButton.add_theme_font_size_override("font_size", int(32 * scale_mod))
	$StartButton.reset_size()
	$StartButton.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	$ScoreLabel.add_theme_font_size_override("font_size", int(24 * scale_mod))
