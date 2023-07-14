extends TextureRect
class_name slot

@onready var has_item = false
@onready var location = null
@onready var is_parent = false
@onready var parent_location = null
@onready var item_id = null
@onready var texture_empty = preload("res://Assets/temp_slot1.png")
@onready var texture_full = preload("res://Assets/temp_slot2.png")
@onready var texture_not_real = preload("res://Assets/temp_slot3.png")
@onready var slot_type #0 - normal, 1 - wet, 2 - hole, -1 not real
signal slotEntered(the_slot)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_mouse_entered():
	#setState(1)
	if slot_type >= 0:
		emit_signal("slotEntered", self)

func _on_mouse_exited():
	#setState(0)
	pass # Replace with function body.

func setState(s):
	#print('settingstate')
	if slot_type >= 0:
		match s:
			0: $slotModulate.color = "#ffffff00"
			1: $slotModulate.color = "00ff0033"
			2: $slotModulate.color = "ff000033"
			
func addItem(id):
	has_item = true
	item_id = id
	texture = texture_full

func removeItem():
	has_item = false
	item_id = null
	texture = texture_empty

func setType(t):
	slot_type = t
	match slot_type:
		0: texture = texture_empty
		-1: 
			texture = texture_not_real
