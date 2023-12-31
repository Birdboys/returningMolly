extends Node
@onready var dialogue_json_path = "res://Assets/dialogueJsons/%s.json"
@onready var dialogue_data
# Called when the node enters the scene tree for the first time.
func _ready():		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func loadDialogue(name):
	var path = dialogue_json_path % name
	if not FileAccess.file_exists(path):
		print("DIALOGUE DATA LOADING ERROR")
		return
	var data = FileAccess.open(path, FileAccess.READ)
	dialogue_data = JSON.parse_string(data.get_as_text())
	data.close()

func dialogueChoice(choiceID):
	match choiceID:
		"intro_5a","intro_5b","intro_5c":
			PlayerData.user_data['breakfast'] = choiceID
			PlayerData.save_user()
		"day2_42a","day2_42b","day2_42c":
			PlayerData.user_data['shopkeeper_choice'] = choiceID
			PlayerData.save_user()
		_:
			pass
func to_title(s: String):
	s = s.strip_edges()
	return s.substr(0,1).to_upper() + s.substr(1).to_lower()
	
