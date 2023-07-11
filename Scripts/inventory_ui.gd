extends Control
@onready var num_col = 8
@onready var num_row = 6
@onready var slot = preload("res://Scenes/temp_slot.tscn")
@onready var slot_height 
@onready var slot_width
@onready var current_slot
@onready var held_item = null
@onready var hovered_item = null
# Called when the node enters the scene tree for the first time.
func _ready():
	for row in range(num_row):
		for col in range(num_col):
			var new_slot = slot.instantiate()
			if row%2 == col%2:
				new_slot.color = '#ada387'
			else:
				new_slot.color = '#ffffff'
			#new_slot.text=('%s,%s'%[row,col])
			$Panel/GridContainer.add_child(new_slot)
			new_slot.slotEntered.connect(slotEntered)
			new_slot.location = Vector2(col, row)
	slot_height = $Panel/GridContainer.size.y/num_row
	slot_width = $Panel/GridContainer.size.x/num_col
	print(slot_height, slot_width)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if held_item == null:
		if Input.is_action_just_pressed("ui_input"):
			if hovered_item:
				held_item = hovered_item
				held_item.pickUp()
	else:
		if Input.is_action_just_pressed("ui_input"):
			held_item.putDown()
			held_item = null
	print(held_item, hovered_item)
	
func _on_grid_container_gui_input(event):
	if event.is_action_pressed("ui_input"):
		var mouse_pos = get_global_mouse_position()
		print(getContainerLoc(mouse_pos))
	if event.is_action_released("ui_input"):
		#print('release')
		pass # Replace with function body.

func getContainerLoc(mouse_pos):
	var container_pos = mouse_pos - $Panel/GridContainer.global_position
	return [int(container_pos.x/slot_width), int(container_pos.y/slot_height)]

func slotEntered(the_slot):
	current_slot = the_slot
	pass
	
func slotExited(the_slot):
	current_slot=null
	pass

func itemEntered(the_item):
	if held_item:
		return
	hovered_item = the_item
	print("entered", the_item)
	pass
func itemExited(the_item):
	if held_item:
		return
	hovered_item = null
	print("exited", the_item)
	pass
func _on_button_pressed():
	var new_item = load("res://Scenes/item.tscn").instantiate()
	add_child(new_item)
	var id = randi_range(0,1)
	new_item.loadItem(id)
	new_item.cursor_entered_item.connect(itemEntered)
	new_item.cursor_exited_item.connect(itemExited)

	pass # Replace with function body.
