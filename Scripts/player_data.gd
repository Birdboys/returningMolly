extends Node
var user_data
@onready var user_data_path = "user://user_data.json"
@onready var default_save_data = {"breakfast":"","shopkeeper_choice":""}
# Called when the node enters the scene tree for the first time.
func _ready():
	user_data = load_user_data(user_data_path)
	save_user()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func save_user():
	var user_file 
	user_file = FileAccess.open(user_data_path, FileAccess.WRITE)
	user_file.store_line(JSON.stringify(user_data))
	user_file.close()

func load_user_data(save_path):
	return default_save_data
	if FileAccess.file_exists(save_path): #we have data
		#var save_data = FileAccess.open_encrypted_with_pass(save_path, FileAccess.READ, 'porbo')
		var save_data = FileAccess.open(save_path, FileAccess.READ)
		var parsed_data = JSON.parse_string(save_data.get_as_text())
		save_data.close()
		if parsed_data is Dictionary:
			return parsed_data
		else:
			print("some kinda system data loading error")	
	else:
		return default_save_data
