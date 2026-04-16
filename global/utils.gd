extends Node


const SAVE_PATH = "res://savegame.json"


func saveGame():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data: Dictionary = {
		"playerHP": Game.playerHP,
		"playerGP": Game.playerGP
	}
	
	var json = JSON.stringify(data)
	file.store_line(json)


func loadGame():
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if FileAccess.file_exists(SAVE_PATH):
		if not file.eof_reached():
			var data = JSON.parse_string(file.get_line())
			if data:
				Game.playerHP = data["playerHP"]
				Game.playerGP = data["playerGP"]
