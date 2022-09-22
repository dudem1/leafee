extends Node

var menu_start_animation = 1
var last_level_opened = 1
var tile_size = 48
var inputs = {
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
	"down": Vector2.DOWN
}
var speed = 8

func _ready():
	var config = ConfigFile.new()
	var err = config.load("user://config.cfg")

	if err == OK and config.has_section("config"):
		if config.has_section_key("config", "last_level_opened"):
			last_level_opened = config.get_value("config", "last_level_opened")

		if config.has_section_key("config", "mute_music"):
			MusicController.toggleMusic(!config.get_value("config", "mute_music"))

		if config.has_section_key("config", "mute_fx"):
			AudioServer.set_bus_mute(AudioServer.get_bus_index("fx"), config.get_value("config", "mute_fx"))
	else:
		MusicController.toggleMusic(true)

func save(parameter, value):
	var config = ConfigFile.new()
	config.load("user://config.cfg")
	config.set_value("config", parameter, value)
	config.save("user://config.cfg")
