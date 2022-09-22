extends Node2D

func _on_AnimationPlayer_animation_finished(_anim_name):
	return get_tree().change_scene("res://menu/Menu.tscn")
