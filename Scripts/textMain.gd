extends Control
var textData
var textId
@onready var text = $textMainPanel/textMargin/textMainText
@onready var speaker = $textSpeaker
@onready var listener = $textListener
@onready var bbStrip = RegEx.new()
@onready var typeTimer
@onready var visible_ration = 0.0
@onready var finished_typing = false
@onready var typing_increase 
@onready var speaker_dict = {'dad':' Dad ', 'girl': ' Molly ', 'news': ' News ', 'father':' Harold '}
#TEXT_ID	TEXT_TEXT	TEXT_TYPE	TEXT_SPEAKER	NEXT_TEXT_ID	HAS_CHOICE	IS_END
# Called when the node enters the scene tree for the first time.
func _ready():
	text.clear()
	speaker.clear()
	bbStrip.compile("\\[.*?\\]")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func initialize(textID):
	textData = DialogueManager.dialogue_data[textID]
	textId = textID
	text.parse_bbcode(textData['TEXT_TEXT'])
	typing_increase = 1.0/float(len(text.get_parsed_text()))
	typeTimer = Timer.new()
	add_child(typeTimer)
	typeTimer.timeout.connect(stepTyping)
	typeTimer.one_shot = true
	typeTimer.start(.03)
	startTyping()
	
	match textData['TEXT_TYPE']:
		'listen': setListener(getSpeaker(textData['TEXT_SPEAKER']))
		'talk': setSpeaker(getSpeaker(textData['TEXT_SPEAKER']))
		'think': setThink()
		
	match textData['TEXT_SPEAKER']:
		'dad','girl': set_theme(load("res://Assets/themes/text_main_%s.tres" % textData['TEXT_SPEAKER']))
		_: set_theme(load("res://Assets/themes/text_main_default.tres"))

	
func nextText():
	return [textData["HAS_CHOICE"], textData["NEXT_TEXT_ID"]]

func setSpeaker(t):
	speaker.clear()
	speaker.visible = true
	listener.visible = false
	speaker.parse_bbcode(t)
	
func setListener(t):
	listener.clear()
	listener.visible = true
	speaker.visible = false
	listener.parse_bbcode(t)

func setThink():
	listener.visible = false
	speaker.visible = false
func setTheme(theme_id):
	pass

func startTyping():
	text.visible_ratio = 0
	finished_typing = false

func stepTyping():
	text.visible_ratio += typing_increase
	if text.visible_ratio >= 1:
		finishTyping()
	else:
		typeTimer.start(.03)

func finishTyping():
	typeTimer.stop()
	typeTimer.queue_free()
	text.visible_ratio = 1
	finished_typing = true

func getSpeaker(s):
	if s in speaker_dict:
		return speaker_dict[s]
	else:
		return " %s " % DialogueManager.to_title(s)
