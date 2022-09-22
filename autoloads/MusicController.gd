extends Node

func isMusicPlaying():
	return $Music.playing

func toggleMusic(value = !$Music.playing):
	$Music.playing = value

func playClick():
	$Click.play()
