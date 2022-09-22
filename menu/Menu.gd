extends Control

var selected_level = 1

func _ready():
	$AnimationPlayer.play("menu_start_animation" + str(Global.menu_start_animation))

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "menu_end_animation":
		return get_tree().change_scene("res://levels/Level" + str(selected_level) + ".tscn")
