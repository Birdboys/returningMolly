extends TextureButton
var item_id
signal item_pressed(id)
signal get_description(id)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func loadItemButton(id):
	texture_normal = load("res://Assets/objects/%s.png" % ItemLoader.item_data[str(id)]["item_name"])
	item_id = id

func _on_pressed():
	print("pressed")
	#if Input.is_action_pressed("ui_input"):
	print("LEFT CLICK")
	print("PRESSED THE BUTTON", item_id)
	emit_signal("item_pressed", item_id)
	queue_free()
	#if Input.is_action_pressed("ui_right_input"):
		#print("RIGHT CLICK")
	pass # Replace with function body.



func _on_gui_input(event):
	if event.is_action_pressed("ui_right_input"):
		emit_signal("get_description", item_id)
	pass # Replace with function body.
