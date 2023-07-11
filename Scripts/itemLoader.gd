extends Node
@onready var item_data
@onready var item_json_path = "res://Assets/item_list.json"


# Called when the node enters the scene tree for the first time.
func _ready():
	loadItems()
	#loadItemGrids()
	print(item_data)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func loadItems():
	if not FileAccess.file_exists(item_json_path):
		print("ITEM DATA LOADING ERROR")
		return
	var data = FileAccess.open(item_json_path, FileAccess.READ)
	item_data = JSON.parse_string(data.get_as_text())
	data.close()
	
	for item in item_data:
		var points = item_data[item]['item_graph'].split('/')
		var temp_array = []
		for point in points:
			var offset_point = Vector2(int(point.split(',')[0]),int(point.split(',')[1]))
			temp_array.append(offset_point)
		item_data[item]['item_graph'] = temp_array
	
