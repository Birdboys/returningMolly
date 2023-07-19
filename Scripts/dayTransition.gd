extends Control
@export var transition_done := false
var next_day
@onready var titles = {'intro':'Returning\nto Molly', "day0": "Day 0", "day1": "Day 1"}
@onready var subtitles = {'intro':'A game by Colby Bird', "day0":"Doomsday", "day1":"Embark"}

signal finished_transition(next)
# Called when the node enters the scene tree for the first time.
func _ready():
	$anim.play("begin")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

func initialize(nextDay):
	next_day = nextDay
	$cont/title.clear()
	$cont/title.parse_bbcode("[center]%s[/center]" % titles[nextDay])
	$cont/subtitle.clear()
	$cont/subtitle.parse_bbcode("[center][u]%s[/u][/center]" % subtitles[nextDay])

func _on_gui_input(event):
	if transition_done:
		if event.is_action_pressed("ui_input"):
			emit_signal("finished_transition", next_day)
			queue_free()
	pass # Replace with function body.
