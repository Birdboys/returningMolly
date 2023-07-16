extends Control
var textData
var textId
@onready var text = $textMainPanel/textMargin/textMainText
@onready var speaker = $textSpeaker
@onready var listener = $textListener
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
	
	match textData['TEXT_TYPE']:
		'listen': setListener(textData['TEXT_SPEAKER'])
		'talk': setSpeaker(textData['TEXT_SPEAKER'])
		'think': setThink()
	print("res://Assets/themes/text_main_%s.tres" % textData['TEXT_SPEAKER'])
	set_theme(load("res://Assets/themes/text_main_%s.tres" % textData['TEXT_SPEAKER']))
	print(theme)
	
func nextText():
	return [textData["HAS_CHOICE"], textData["NEXT_TEXT_ID"]]

func setSpeaker(t):
	speaker.clear()
	speaker.visible = true
	listener.visible = false
	speaker.parse_bbcode(" " + DialogueManager.to_title(t) + " ")
	
func setListener(t):
	listener.clear()
	listener.visible = true
	speaker.visible = false
	listener.parse_bbcode(" " + DialogueManager.to_title(t) + " ")

func setThink():
	listener.visible = false
	speaker.visible = false
func setTheme(theme_id):
	pass
