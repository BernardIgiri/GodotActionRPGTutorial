extends Control

onready var pause_sound = $PauseSound
onready var unpause_sound = $UnPauseSound
onready var menu_move_sound = $MenuMoveSound
onready var menu_select_sound = $MenuSelectSound
onready var menu = $Menu

func _ready():
	visible = false
	for button in menu.get_children():
		button.connect("focus_entered", self, "play_menu_move_sound")

func _input(event):
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			unpause()
		else:
			pause()

func pause():
	get_tree().paused = true
	visible = true
	pause_sound.play()
	menu.get_child(0).grab_focus()

func unpause():
	get_tree().paused = false
	visible = false
	unpause_sound.play()

func play_menu_move_sound():
	menu_move_sound.play()

func play_menu_select_sound():
	menu_select_sound.play()

func _on_ExitButton_pressed():
	play_menu_select_sound()

func _on_RestartButton_pressed():
	unpause()

func _on_ResumeButton_pressed():
	unpause()

func _on_MenuSelectSound_finished():
	get_tree().quit()
