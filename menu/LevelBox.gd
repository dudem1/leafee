extends PanelContainer

var locked = true setget setLocked
var level_num = 0 setget setLevel

func _ready():
	setLevel(self.name.substr(8))

func setLocked(value):
	locked = value
	$MarginContainer.visible = value
	$Label.visible = !value
	
func setLevel(value):
	level_num = int(value)
	$Label.text = str(level_num)
	setLocked(Global.last_level_opened < level_num)

func _on_LevelBox_gui_input(event):
	if !locked and event is InputEventMouseButton and event.pressed:
		MusicController.playClick()
		var menu = get_tree().root.get_node("Menu")
		menu.selected_level = level_num
		menu.get_node("AnimationPlayer").play("menu_end_animation")
