extends Panel
var textData
var textId
@onready var text = $textMargin/textOptionText

signal dialogue_choice(choiceData)
#TEXT_ID	TEXT_TEXT	TEXT_TYPE	TEXT_SPEAKER	NEXT_TEXT_ID	HAS_CHOICE	IS_END
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_mouse_entered():
	print("entered text box")
	scale = Vector2(1.05,1.05)
func _on_mouse_exited():
	print("exited text box")
	scale = Vector2(1.,1.)

func initialize(textID):
	textId = textID
	textData = DialogueManager.dialogue_data[textID]
	text.parse_bbcode(textData['TEXT_TEXT'])
	set_theme(load("res://Assets/themes/text_choice_%s.tres" % textData['TEXT_SPEAKER']))
func _on_gui_input(event):
	if event.is_action_pressed("dialogue_choice_input"):
		emit_signal("dialogue_choice", textId, textData)
	pass # Replace with function body.
