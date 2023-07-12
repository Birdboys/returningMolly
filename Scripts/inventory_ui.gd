extends Control
@onready var num_col = 8
@onready var num_row = 6
@onready var slot = preload("res://Scenes/temp_slot.tscn")
@onready var slot_height 
@onready var slot_width
@onready var current_slot
@onready var held_item = null
@onready var hovered_item = null
@onready var slots = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	for row in range(num_row):
		for col in range(num_col):
			var new_slot = slot.instantiate()

			new_slot.color = '#ada387'
			#new_slot.text=('%s,%s'%[row,col])
			$gridPanel/GridContainer.add_child(new_slot)
			new_slot.slotEntered.connect(slotEntered)
			new_slot.location = Vector2(col, row)
			slots['%s:%s' %[col, row]] = new_slot
	slot_height = $gridPanel/GridContainer.size.y/num_row
	slot_width = $gridPanel/GridContainer.size.x/num_col
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if held_item == null:
		if Input.is_action_just_pressed("ui_input"):
			if hovered_item:
				held_item = hovered_item
				if hovered_item.item_location:
					#print(hovered_item.item_location)
					for coord in hovered_item.item_coords:
						var slot_to_update = hovered_item.item_location + coord
						print(slot_to_update)
						slots["%s:%s"%[slot_to_update.x, slot_to_update.y]].removeItem()
				held_item.pickUp()
				#print(held_item.item_location)
		for child in $groundPanel/groundItemsScroll/groundItems.get_children():
			child.mouse_filter = 1
	else:
		var slot_to_check = getContainerLoc(get_global_mouse_position())
		if Rect2(Vector2(0,0), Vector2(8,6)).has_point(slot_to_check):
			slotEntered(slots["%s:%s"%[slot_to_check.x,slot_to_check.y]])
			
			if Input.is_action_just_pressed("ui_input"):
				if checkSlotsAvailable(current_slot):
					putItemDown(current_slot)
					
		else:
			current_slot = null
			clearItemSlots()
			if Input.is_action_just_pressed("ui_input"):
				held_item.putDown()
				held_item = null
				
			#current_slot = 
		for child in $groundPanel/groundItemsScroll/groundItems.get_children():
		
			child.mouse_filter = 2
			#print(child.mouse_filter)
	#print(held_item, hovered_item)

func getContainerLoc(mouse_pos):
	var container_pos = mouse_pos - $gridPanel/GridContainer.global_position
	return Vector2(int(container_pos.x/slot_width), int(container_pos.y/slot_height))

func slotEntered(the_slot):
	clearItemSlots()
	current_slot = the_slot
	if held_item:
		if checkSlotsAvailable(current_slot): #item fits
			updateItemSlots(current_slot, 1)
		else:
			updateItemSlots(current_slot, 2)
	pass
	
func slotExited(the_slot):
	current_slot=null
	pass

func itemEntered(the_item):
	if held_item:
		return
	hovered_item = the_item
	pass
func itemExited(the_item):
	if held_item:
		return
	hovered_item = null
	pass
func _on_button_pressed():
	var id = randi_range(0,2)
	addItemToGround(id)

func checkSlotsAvailable(the_slot):
	var main_slot_location = the_slot.location
	for coord in held_item.item_coords:
		var slot_to_check = main_slot_location + coord
		if Rect2(Vector2(0,0), Vector2(8,6)).has_point(slot_to_check):
			if slots["%s:%s"%[slot_to_check.x, slot_to_check.y]].has_item:
				return false
		else:
			return false
	return true

func updateItemSlots(the_slot, state):
	var main_slot_location = the_slot.location
	for coord in held_item.item_coords:
		var slot_to_check = main_slot_location + coord
		if Rect2(Vector2(0,0), Vector2(8,6)).has_point(slot_to_check):
			slots["%s:%s"%[slot_to_check.x, slot_to_check.y]].setState(state)

func clearItemSlots():
	for s in slots:
		slots[s].setState(0)
		
func putItemDown(the_slot):
	var main_slot_location = the_slot.location
	print(main_slot_location)
	held_item.item_location = main_slot_location
	for coord in held_item.item_coords:
		var slot_to_check = main_slot_location + coord
		slots["%s:%s"%[slot_to_check.x, slot_to_check.y]].addItem(held_item.item_id)
	
	held_item.putDown(slots["%s:%s"%[main_slot_location.x, main_slot_location.y]].global_position)
	held_item = null

func addItemToGround(id):
	var new_item_button = load("res://Scenes/item_button.tscn").instantiate()
	$groundPanel/groundItemsScroll/groundItems.add_child(new_item_button)
	new_item_button.loadItemButton(id)
	new_item_button.item_pressed.connect(groundItemPressed)
	hovered_item = null
	
func groundItemPressed(id):
	var new_item = load('res://Scenes/item.tscn').instantiate()
	add_child(new_item)
	new_item.loadItem(id)
	new_item.cursor_entered_item.connect(itemEntered)
	new_item.cursor_exited_item.connect(itemExited)
	new_item.return_to_ground.connect(addItemToGround)
	held_item = new_item
	new_item.pickUp()
	
