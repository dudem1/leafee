extends Control

var bus_fx = AudioServer.get_bus_index("fx")
var level_number = 5

func _ready():
	$menu_panel/HBoxContainer/mute_music.pressed = !MusicController.isMusicPlaying()
	$menu_panel/HBoxContainer/mute_fx.pressed = AudioServer.is_bus_mute(bus_fx)
	level_number = int(get_tree().get_current_scene().filename.substr(13))
	$Title.text += str(level_number)

func tweenMenuPanel(button_pressed):
	var x_begin = 0
	var x_end = -169

	if button_pressed:
		x_begin = -169
		x_end = 0

	$menu_panel/Tween.interpolate_property(
		$menu_panel,
		"rect_position:x", 
		x_begin,
		x_end,
		0.1,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT
	)
	$menu_panel/Tween.start()

func _on_menu_button_toggled(button_pressed):
	if !$"../Objekty/Player".can_move: return

	MusicController.playClick()
	tweenMenuPanel(button_pressed)

func _on_select_level_pressed():
	MusicController.playClick()
	Global.menu_start_animation = 2
	$"../AnimationPlayer".play("level_fade_out")

# Prechod do menu
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "level_fade_out":
		return get_tree().change_scene("res://menu/Menu.tscn")

# Prechod do dalsieho levelu
func _on_AnimationPlayer2_animation_finished(anim_name):
	if anim_name == "citat_animation":
		var t = Timer.new()
		t.set_wait_time(6)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()
		$"../AnimationPlayer2".play("level_fade_out")
	elif anim_name == "level_fade_out":
		var last_level_opened = level_number + 1

		if ResourceLoader.exists("res://levels/Level" + str(last_level_opened) + ".tscn"):
			if last_level_opened > Global.last_level_opened:
				Global.last_level_opened = last_level_opened
				Global.save("last_level_opened", last_level_opened)

			return get_tree().change_scene("res://levels/Level" + str(last_level_opened) + ".tscn")
		else:
			return get_tree().change_scene("res://game_over/game_over.tscn")

func _on_restart_pressed():
	MusicController.playClick()
	return get_tree().reload_current_scene()

func _on_restart_button_pressed():
	if !$"../Objekty/Player".can_move: return

	MusicController.playClick()
	return get_tree().reload_current_scene()

func _on_undo_button_pressed():
	if !$"../Objekty/Player".can_move: return

	closePopUps()
	$steps.undo()

func _on_mute_music_pressed():
	MusicController.playClick()

func _on_mute_music_toggled(button_pressed):
	MusicController.toggleMusic(!button_pressed)
	Global.save("mute_music", button_pressed)

func _on_mute_fx_toggled(button_pressed):
	MusicController.playClick()
	AudioServer.set_bus_mute(bus_fx, button_pressed)
	Global.save("mute_fx", button_pressed)

func tweenInformationPanel(button_pressed):
	var begin = 1
	var end = 0

	if button_pressed:
		$information_panel.visible = true
		begin = 0
		end = 1

	$information_panel/Tween.interpolate_property(
		$information_panel,
		"modulate:a", 
		begin,
		end,
		0.1,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT
	)
	$information_panel/Tween.start()

func _on_Tween_tween_all_completed():
	if !$information_button.pressed: $information_panel.visible = false

func _on_information_button_toggled(button_pressed):
	if !$"../Objekty/Player".can_move: return

	MusicController.playClick()
	tweenInformationPanel(button_pressed)

func closePopUps():
	$menu_button.pressed = false
	$information_button.pressed = false

func tweenRotate(button, entered):
	var from = 20
	var to = 0

	if entered:
		var from2 = from
		from = to
		to = from2

	var tween = button.get_node("Tween")
	tween.interpolate_property(
		button,
		"rect_rotation",
		from,
		to,
		0.2,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT
	)
	tween.start()

func _on_menu_button_mouse_entered():
	tweenRotate($menu_button, true)

func _on_menu_button_mouse_exited():
	tweenRotate($menu_button, false)

func _on_restart_button_mouse_entered():
	tweenRotate($restart_button, true)

func _on_restart_button_mouse_exited():
	tweenRotate($restart_button, false)

func _on_undo_button_mouse_entered():
	tweenRotate($undo_button, true)

func _on_undo_button_mouse_exited():
	tweenRotate($undo_button, false)

func _on_information_button_mouse_entered():
	tweenRotate($information_button, true)

func _on_information_button_mouse_exited():
	tweenRotate($information_button, false)

func _on_Gui_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		closePopUps()
