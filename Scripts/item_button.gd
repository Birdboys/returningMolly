extends TextureButton
var item_id
signal item_pressed(id)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func loadItemButton(id):
	texture_normal = load("res://Assets/%s.png" % id)
	item_id = id

func _on_pressed():
	print("PRESSED THE BUTTON", item_id)
	emit_signal("item_pressed", item_id)
	queue_free()
	pass # Replace with function body.
