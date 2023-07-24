extends Control
@onready var dialogueScene = preload("res://Scenes/dialogue.tscn")
@onready var inventoryScene = preload("res://Scenes/inventory.tscn")
@onready var transition = preload("res://Scenes/day_transition.tscn")
var currentInventory = null
var currentDialogue = null
var nextDialogue = null
var currentDay
var dayData = {"intro":[true, true, "introNight"], "introNight":[false, false, "day0"],"day0":[true, true, "day0Night"], "day0Night":[false, false, "day1"], "day1":[true,true,"day1Night"], 
				"day1Night": [false, false, "day2"], "day2":[true, true,"day2Night"], "day2Night":[false, false,"day3"],"tempLooper":[false, true,"tempLooper"]}
@onready var objects_in_inventory = {}
@onready var water_objects = {1:5, 6:1, 11:2}
@onready var food_objects = {3:5, 5:1}
@onready var weapon_objects = []
@onready var is_alive_tomorrow = 0
# Called when the node enters the scene tree for the first time.
@onready var dad_edges = [Vector2(0, 0), Vector2(1, 0), Vector2(2, 0), Vector2(3, 0), Vector2(4, 0), Vector2(5, 0), Vector2(6, 0), Vector2(7, 0), Vector2(8, 0), Vector2(9, 0), Vector2(9, 1), Vector2(9, 2), Vector2(9, 3), Vector2(9, 4), Vector2(9, 5), Vector2(9, 6), Vector2(9, 7), Vector2(8, 7), Vector2(7, 7), Vector2(6, 7), Vector2(5, 7), Vector2(4, 7), Vector2(3, 7), Vector2(2, 7), Vector2(1, 7), Vector2(0, 7), Vector2(0, 6), Vector2(0, 5), Vector2(0, 4), Vector2(0, 3), Vector2(0, 2), Vector2(0, 1), Vector2(1, 1), Vector2(8, 1), Vector2(8, 6), Vector2(1, 6)]
@onready var girl_edges = [Vector2(0, 0), Vector2(1, 0), Vector2(2, 0), Vector2(3, 0), Vector2(4, 0), Vector2(5, 0), Vector2(6, 0), Vector2(7, 0), Vector2(8, 0), Vector2(9, 0), Vector2(9, 1), Vector2(9, 2), Vector2(9, 3), Vector2(9, 4), Vector2(9, 5), Vector2(9, 6), Vector2(9, 7), Vector2(8, 7), Vector2(7, 7), Vector2(6, 7), Vector2(5, 7), Vector2(4, 7), Vector2(3, 7), Vector2(2, 7), Vector2(1, 7), Vector2(0, 7), Vector2(0, 6), Vector2(0, 5), Vector2(0, 4), Vector2(0, 3), Vector2(0, 2), Vector2(0, 1), Vector2(1, 1), Vector2(1, 2), Vector2(1, 3), Vector2(1, 4), Vector2(1, 5), Vector2(1, 6), Vector2(8, 1), Vector2(8, 2), Vector2(8, 3), Vector2(8, 4), Vector2(8, 5), Vector2(8, 6), Vector2(7, 6), Vector2(6, 6), Vector2(5, 6), Vector2(4, 6), Vector2(3, 6), Vector2(2, 6), Vector2(2, 1), Vector2(3, 1), Vector2(4, 1), Vector2(5, 1), Vector2(6, 1), Vector2(7, 1)]
func _ready():
	currentDay = 'day1'
	startDialogue(currentDay)
	#startTutorial()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func startTutorial():
	currentDay = "intro"
	startDialogue(currentDay, dayData[currentDay][0])

func startDay(day):
	startDialogue(day)
func startDialogue(dialogueID, add_transition=false, start_index=0):
	if currentDialogue:
		currentDialogue.queue_free()
		currentDialogue = null
	if add_transition:
		await startTransition(dialogueID)
	DialogueManager.loadDialogue(dialogueID)
	currentDialogue = dialogueScene.instantiate()
	add_child(currentDialogue)
	currentDialogue.initialize(dialogueID+"_%s"% start_index)
	currentDialogue.end_of_dialogue.connect(endDialogue)
	
func startInventory():
	currentInventory = null
	currentInventory = inventoryScene.instantiate()
	add_child(currentInventory)
	currentInventory.initialize(10, objects_in_inventory, getGroundItems(currentDay), dad_edges, 0)
	currentInventory.inventory_finished.connect(endInventory)

func endInventory(placed_objects):
	if "intro" not in currentDay:
		objects_in_inventory = placed_objects
		is_alive_tomorrow = processInventory()
	else:
		is_alive_tomorrow = 0
		
	currentDay = dayData[currentDay][2]
	
	match is_alive_tomorrow:
		0: startDialogue(currentDay, dayData[currentDay][0])
		1: startDialogue("dieFood")
		2: startDialogue("dieWater")
		3: startDialogue("noWalkie")

func endDialogue(dialogueID):
	currentDialogue.queue_free()
	currentDialogue = null
	match dialogueID:
		"intro_19": #FINISHED INTRO 1
			currentInventory = inventoryScene.instantiate()
			add_child(currentInventory)
			currentInventory.initialize(10, {}, [0,1,2,3,4], girl_edges, 1)
			currentInventory.inventory_finished.connect(endInventory)
		"introNight_11":
			currentDay = dayData[currentDay][2]
			startDialogue(currentDay, true)
		"day0_9":
			if currentInventory:
				currentInventory.queue_free()
			currentInventory = null
			currentInventory = inventoryScene.instantiate()
			add_child(currentInventory)
			currentInventory.initialize(10, {}, [5,5,8,1,5,6,7], girl_edges, 1)
			currentInventory.inventory_finished.connect(endInventory)
		"dieWater_5", "dieFood_4":
			pass
		"day2_29c":
			if 4 in objects_in_inventory.values():
				startDialogue(currentDay, false, "30a")
			else:
				startDialogue(currentDay, false, "30b")
		"day2_43b":
			if removeFromInv([8]):
				print("SUCCESSFUL WALKIE TRADE")
				startDialogue(currentDay, false, "44b")
			else:
				print("FAILED WALKIE TRADE")
				startDialogue(currentDay, false, "44c")
				PlayerData.user_data['shopkeeper_choice'] = 'ran_away'
		"day2_43c":
			if removeFromInv([7,9]):
				print("SUCCESSFUL WEAPON TRADE")
				startDialogue(currentDay, false, "44b")
			else:
				print("FAILED WEAPON TRADE")
				startDialogue(currentDay, false, "44c")
				PlayerData.user_data['shopkeeper_choice'] = 'ran_awaay'
		"day2_47c":
			removeFromInv([5])
			removeFromInv([6])
			startInventory()
		_:
			print(currentDay)
			if dayData[currentDay][1]: #go to inventory
				startInventory()
			else:
				currentDay = dayData[currentDay][2]
				startDialogue(currentDay, dayData[currentDay][0])
				
func startTransition(day):
	var new_transition = transition.instantiate()
	add_child(new_transition)
	new_transition.initialize(day)
	await new_transition.finished_transition
	
func endTransition(day):
	pass

func getGroundItems(day):
	match day:
		"day1": #food, water, walkie, map, 
			return [4,6,6,6,6,5,5,5,5,8,8,7,9,10,11,11,12]
		"day2":
			match PlayerData.user_data['shopkeeper_choice']:
				"": return []
				"day2_42a": return [5,5,6,6]
				"day2_42b": return [5,5,5,5,5,6,6]
				"day2_42c": return [5,5,6,6,6,6,6]
				"ran_away": return []
		"tempLooper": return [6,6,6,6,6,5,5,5,5,9, 11]
		_: return []

func processInventory():
	var water_level = 0
	var food_level = 0
	var food_used = []
	var water_used = []
	for obj in objects_in_inventory:
		if water_level < 2 and objects_in_inventory[obj] in water_objects:
			var water_source = objects_in_inventory[obj]
			var water_lvl = water_objects[water_source]
			if water_lvl == 2:
				water_used.append(obj)
				water_level = 2
				continue
			else:
				water_used.append(obj)
				water_level += water_lvl
		if food_level < 1 and objects_in_inventory[obj] in food_objects:
			food_used.append(obj)
			food_level = 1
			continue
	print("FOOD LEVEL: %s   WATER LEVEL: %s" % [food_level, water_level])
	if water_level < 2:
		return 2
	if food_level < 1:
		return 1
	for water in water_used:
		objects_in_inventory.erase(water)
	for food in food_used:
		objects_in_inventory.erase(food)
	if 8 not in objects_in_inventory.values():
		return 3
	return 0
	pass
	
func removeFromInv(item_ids):
	for obj in objects_in_inventory:
		if objects_in_inventory[obj] in item_ids:
			objects_in_inventory.erase(obj)
			return true
	return false
