extends Control
var textData
var textId
@onready var text = $textMainPanel/textMargin/textMainText
@onready var speaker = $textSpeaker
#TEXT_ID	TEXT_TEXT	TEXT_TYPE	TEXT_SPEAKER	NEXT_TEXT_ID	HAS_CHOICE	IS_END
# Called when the node enters the scene tree for the first time.
func _ready():
	text.clear()
	speaker.clear()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func initialize(textID):
	textData = DialogueManager.dialogue_data[textID]
	textId = textID
	text.parse_bbcode(textData['TEXT_TEXT'])
	speaker.parse_bbcode(" " + DialogueManager.to_title(textData['TEXT_SPEAKER']))
	
func nextText():
	return [textData["HAS_CHOICE"], textData["NEXT_TEXT_ID"]]
