extends Control
@onready var textChoice = load("res://Scenes/text_option.tscn")
@onready var textMain = load("res://Scenes/text_main.tscn")
@onready var choicesBox = $choicesBox
@onready var mainText
@onready var inChoice = false
@onready var can_continue = false
signal end_of_dialogue(id)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_gui_input(event: InputEvent):
	if event.is_action_pressed("dialogue_input") and not inChoice:
		if mainText.finished_typing:
			changeMainText()
		else:
			mainText.finishTyping()
	
	pass # Replace with function body.

func changeMainText():
	clearChoices()
	can_continue = false
	var next = mainText.nextText()
	if next[0]: #Choice option
		inChoice = true
		for choice in next[1]:
			var new_choice = textChoice.instantiate()
			choicesBox.add_child(new_choice)
			new_choice.initialize(choice)
			new_choice.dialogue_choice.connect(dialogueChoice)
	else: #Next text option
		if len(next[1]) > 0:
			mainText.queue_free()
			mainText = textMain.instantiate()
			add_child(mainText)
			mainText.initialize(next[1][0])
		else: #end of text
			emit_signal("end_of_dialogue", mainText.textId)
		
func clearChoices():
	for child in choicesBox.get_children():
		child.queue_free()

func dialogueChoice(id, data):
	DialogueManager.dialogueChoice(id)
	inChoice = false
	clearChoices()
	mainText.queue_free()
	mainText = textMain.instantiate()
	add_child(mainText)
	
	mainText.initialize(data['NEXT_TEXT_ID'][0])

func initialize(init_text):
	mainText = textMain.instantiate()
	add_child(mainText)
	mainText.initialize(init_text)
