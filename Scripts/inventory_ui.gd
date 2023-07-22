extends Control
@onready var sussy_slots = 1
@onready var num_col = 10
@onready var num_row = 8
@onready var inv_slot = preload("res://Scenes/temp_slot.tscn")
@onready var slot_height 
@onready var slot_width
@onready var current_slot
@onready var held_item = null
@onready var hovered_item = null
@onready var slots = {}
@onready var edge_slots = []
@onready var placed_objects := {}
@onready var ground_objects = [0,1,2,2,1,3,0]
@onready var inventoryGrid = $inventoryPanel/inventoryGrid
@onready var groundItems = $infoPanel/infoVbox/groundItemsScroll/groundItemsGrid
@onready var scroll = $infoPanel/infoVbox/groundItemsScroll
@onready var map = $infoPanel/infoVbox/mapPanel
@onready var description = $infoPanel/infoVbox/descriptionPanel
@onready var objects = $inventoryPanel/Objects
@onready var infoPanel = $infoPanel
@onready var tabBar = $infoPanel/infoVbox/TabBar
@onready var uiAnim = $uiAnim
@onready var finishButton = $inventoryPanel/finishButton
@onready var inv_scale
@onready var finish_criteria
@export var infoOpen := false
var inventory_bounding_rect
var inventory_bounding_rect2

signal inventory_finished(po)
# Called when the node enters the scene tree for the first time.
func _ready():
	#initialize(10,{})
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if held_item == null:
		if hovered_item and Input.is_action_just_pressed("ui_right_input"):
			openItemDescription(hovered_item.item_id)
		if Input.is_action_just_pressed("ui_input"):
			if hovered_item:
				held_item = hovered_item
				if held_item.item_location != null:
					placed_objects.erase(held_item.item_location)
					for coord in held_item.item_coords:
						var slot_to_update = held_item.item_location + coord
						slots["%s:%s"%[slot_to_update.x, slot_to_update.y]].removeItem()
				else:
					print("item found on ground")
				held_item.pickUp()
				#print(held_item.item_location)
		for child in groundItems.get_children():
			child.mouse_filter = 1
		finishButton.mouse_filter = 1
		tabBar.mouse_filter = 1
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	else:
		var slot_to_check = getContainerLoc(get_global_mouse_position())
		if inventory_bounding_rect.has_point(slot_to_check):
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
		for child in groundItems.get_children():
			child.mouse_filter = 2
		finishButton.mouse_filter = 2
		tabBar.mouse_filter = 2
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	setFinishButton()
func getContainerLoc(mouse_pos):
	var container_pos = mouse_pos - inventoryGrid.global_position
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

func checkSlotsAvailable(the_slot):
	var main_slot_location = the_slot.location
	for coord in held_item.item_coords:
		var slot_to_check = main_slot_location + coord
		if inventory_bounding_rect.has_point(slot_to_check):
			if slots["%s:%s"%[slot_to_check.x, slot_to_check.y]].has_item or slots["%s:%s"%[slot_to_check.x, slot_to_check.y]].slot_type < 0:
				return false
		else:
			return false
	return true

func updateItemSlots(the_slot, state):
	var main_slot_location = the_slot.location
	for coord in held_item.item_coords:
		var slot_to_check = main_slot_location + coord
		if inventory_bounding_rect.has_point(slot_to_check):
			slots["%s:%s"%[slot_to_check.x, slot_to_check.y]].setState(state)

func clearItemSlots():
	for s in slots:
		slots[s].setState(0)
		
func putItemDown(the_slot):
	clearItemSlots()
	var main_slot_location = the_slot.location
	placed_objects[main_slot_location] = held_item.item_id
	held_item.item_location = main_slot_location
	for coord in held_item.item_coords:
		var slot_to_check = main_slot_location + coord
		slots["%s:%s"%[slot_to_check.x, slot_to_check.y]].addItem(held_item.item_id)
	
	var snap_coords = main_slot_location * slot_height #+ Vector2(slot_width,slot_height)/2
	held_item.putDown(inventoryGrid.global_position+snap_coords)
	hovered_item = held_item
	held_item = null

func addItemToGround(id):
	var new_item_button = load("res://Scenes/item_button.tscn").instantiate()
	groundItems.add_child(new_item_button)
	new_item_button.loadItemButton(id)
	new_item_button.item_pressed.connect(groundItemPressed)
	new_item_button.get_description.connect(openItemDescription)
	hovered_item = null
	scroll.queue_sort()
	
func groundItemPressed(id):
	var new_item = load('res://Scenes/item.tscn').instantiate()
	print("ADDING A NEW ITTEM TO INV")
	objects.add_child(new_item)
	new_item.loadItem(id, Vector2(inv_scale, inv_scale),slot_width)
	#new_item.pivot_offset = new_item.getSize()/2
	new_item.cursor_entered_item.connect(itemEntered)
	new_item.cursor_exited_item.connect(itemExited)
	new_item.return_to_ground.connect(addItemToGround)
	held_item = new_item
	new_item.pickUp()

func _on_tab_bar_tab_selected(tab):
	match tab:
		0: scroll.visible = true; map.visible = false; description.visible = false; if infoOpen: uiAnim.play("close_info") 
		1: scroll.visible = false; map.visible = false; description.visible = true; if not infoOpen: uiAnim.play("open_info")
		2: scroll.visible = false; map.visible = true; description.visible = false; if infoOpen: uiAnim.play("close_info")
	pass # Replace with function body.

func openItemDescription(item_id):
	$infoPanel/infoVbox/descriptionPanel/descriptionMargin/descriptionText.clear()
	$infoPanel/infoVbox/descriptionPanel/descriptionMargin/descriptionText.parse_bbcode(ItemLoader.item_data[str(item_id)]['item_description'])
	_on_tab_bar_tab_selected(1)

func loadInventory():
	for object in placed_objects:
		var the_slot = slots["%s:%s" % [object.x, object.y]]
		var new_item = load('res://Scenes/item.tscn').instantiate()
		objects.add_child(new_item)
		new_item.loadItem(placed_objects[object], Vector2(inv_scale, inv_scale))
		#new_item.pivot_offset = new_item.getSize()/2
		new_item.cursor_entered_item.connect(itemEntered)
		new_item.cursor_exited_item.connect(itemExited)
		new_item.return_to_ground.connect(addItemToGround)
		held_item = new_item
		new_item.pickUp()
		putItemDown(the_slot)
		
func createInventory(girl=false):
	for row in range(num_row):
		for col in range(num_col):
			var new_slot = inv_slot.instantiate()
			inventoryGrid.add_child(new_slot)
			if girl:
				new_slot.is_girl_inv = true
			new_slot.slotEntered.connect(slotEntered)
			new_slot.location = Vector2(col, row)
			slots['%s:%s' %[col, row]] = new_slot
			if new_slot.location in edge_slots:
				new_slot.setType(-1)
			else:
				new_slot.setType(0)
	slot_height = inventoryGrid.size.y/num_row
	slot_width = inventoryGrid.size.x/num_col
	inventory_bounding_rect = Rect2(Vector2(0, 0), Vector2(num_col, num_row))

func loadGround():
	if ground_objects:
		for item in ground_objects:
			addItemToGround(item)

func initialize(col, placed, ground=[1,2,3,4], edge=[], fc=0, girl=false):
	print("STARTING INV INIT")
	num_col = col
	num_row = 4 * col / 5
	placed_objects = placed
	ground_objects = ground
	edge_slots = edge
	finish_criteria = fc
	inv_scale = (800./num_col)/50.
	inventoryGrid.columns = num_col
	createInventory(girl)
	loadInventory()
	loadGround()
	
	if girl:
		#$infoPanel/infoVbox/groundItemsScroll.add_stylebox_override("normal", load("res://Assets/themes/girl_inventory_stylebox.tres"))
		$infoPanel/infoVbox/groundItemsScroll.get_theme_stylebox("normal").bg_color = '#8e6d89'
		print($infoPanel/infoVbox/groundItemsScroll.get_theme_stylebox("normal").bg_color)
func setFinishButton():
	match finish_criteria:
		0: finishButton.disabled = false
		1: 
			if groundItems.get_child_count() == 0:
				finishButton.disabled = false	
			else:
				finishButton.disabled = true

func _on_finish_button_pressed():
	emit_signal("inventory_finished", placed_objects)
	pass # Replace with function body.
