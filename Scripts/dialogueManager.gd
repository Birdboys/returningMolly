extends Node
@onready var dialogue_json_path = "res://Assets/dialogueJsons/%s.json"
@onready var dialogue_data
# Called when the node enters the scene tree for the first time.
func _ready():
	loadDialogue("introNight")
		
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
		"intro5a","intro5b","intro5c":
			PlayerData.user_data['intro']['breakfast'] = choiceID
			print(PlayerData.user_data['intro']['breakfast'])
			PlayerData.save_user()
		_:
			print('Non-important choice')

func to_title(s: String):
	s = s.strip_edges()
	return s.substr(0,1).to_upper() + s.substr(1).to_lower()
	
