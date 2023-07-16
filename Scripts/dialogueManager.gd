extends Node
@onready var dialogue_json_path = "res://Assets/dialogueJsons/%s.json"
@onready var dialogue_data
# Called when the node enters the scene tree for the first time.
func _ready():
	loadDialogue("test")
		
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
