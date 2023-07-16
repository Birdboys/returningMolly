extends Control
@onready var textChoice = load("res://Scenes/text_option.tscn")
@onready var textMain = load("res://Scenes/text_main.tscn")
@onready var choicesBox = $choicesBox
@onready var mainText
# Called when the node enters the scene tree for the first time.
func _ready():
	mainText = textMain.instantiate()
	add_child(mainText)
	mainText.initialize("intro0")
	
	var choice = textChoice.instantiate()
	choicesBox.add_child(choice)
	choice.initialize("intro5b")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_gui_input(event: InputEvent):
	if event.is_action_pressed("dialogue_input"):
		changeMainText()
	pass # Replace with function body.

func changeMainText():
	clearChoices()
	var next = mainText.nextText()
	mainText.queue_free()
	mainText = textMain.instantiate()
	add_child(mainText)
	mainText.initialize(next[1])
	pass
	
func clearChoices():
	for child in choicesBox.get_children():
		child.queue_free()
