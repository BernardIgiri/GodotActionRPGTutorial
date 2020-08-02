extends Control

var stats = PlayerStats
onready var pause_sound = $PauseSound
onready var unpause_sound = $UnPauseSound
onready var menu_move_sound = $MenuMoveSound
onready var menu_select_sound = $MenuSelectSound
onready var game_over_sound = $GameOver
onready var victory_sound = $Victory
onready var menu = $Control/Panel/MarginContainer/VBoxContainer/Menu
onready var die_timeout = $DieTimeout
onready var win_timeout = $WinTimeout
onready var resume_button = $Control/Panel/MarginContainer/VBoxContainer/Menu/ResumeButton
onready var pause_title = $Control/Panel/MarginContainer/VBoxContainer/Label

func _ready():
	stats.connect("no_health", self, "die")
	get_node("/root/World").connect("no_enemies", self, "win")
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
	if get_tree().paused:
		return
	get_tree().paused = true
	visible = true
	if stats.health > 0:
		if get_node("/root/World").enemy_count > 0:
			resume_button.disabled = false
			resume_button.visible = true
			pause_title.text = "Paused"
			pause_sound.play()
			menu.get_child(0).grab_focus()
		else:
			resume_button.disabled = true
			resume_button.visible = false
			pause_title.text = "You Won!"
			menu.get_child(1).grab_focus()
	else:
		resume_button.disabled = true
		resume_button.visible = false
		pause_title.text = "You Died!"
		menu.get_child(1).grab_focus()

func unpause():
	unpause_silent()
	unpause_sound.play()
	
func unpause_silent():
	get_tree().paused = false
	visible = false

func play_menu_move_sound():
	menu_move_sound.play()

func play_menu_select_sound():
	menu_select_sound.play()

func _on_ExitButton_pressed():
	play_menu_select_sound()

func _on_RestartButton_pressed():
	unpause_silent()
	stats.reset()
	get_tree().reload_current_scene()

func _on_ResumeButton_pressed():
	unpause()

func _on_MenuSelectSound_finished():
	get_tree().quit()

func die():
	game_over_sound.play()
	die_timeout.start()
	
func _on_DieTimeout_timeout():
	pause()

func win():
	victory_sound.play()
	win_timeout.start()

func _on_WinTimeout_timeout():
	pause()
