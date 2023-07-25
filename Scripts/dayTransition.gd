extends Control
@export var transition_done := false
var next_day
@onready var titles = {'intro':'Returning\nto Molly', "day0": "Day 0", "day1": "Day 1", "day2":"Day 2", "day3":"Day 3", "day3Night":"The Return", "dieNoWalkie":"Day X", "dieWater":"Day X", "dieFood":"Day X", "endBad":"The End","endGood":"The End", "noWalkie":"The Return", "day4":"The Future"}
@onready var subtitles = {'intro':'A game by Colby Bird', "day0":"Is It Doomsday", "day1":"Beginning the Return", "day2":"A Questionable Encounter", "day3":"Rerouting the Plan", "day3Night":"Will It Succeed","dieNoWalkie":"Lack of Communication", "dieWater":"Thirsty for More","dieFood":"Hungry for More", "endBad":"...but not the best one\nThanks for Playing <3", "endGood":"Hope You Enjoyed\nThanks for Playing <3", "noWalkie":"Will it Succeed", "day4":"New Beginnings"}

signal finished_transition(next)
# Called when the node enters the scene tree for the first time.
func _ready():
	$anim.play("begin")

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
			finish()
	pass # Replace with function body.

func finish():
	print("finished")
	emit_signal("finished_transition", next_day)
	queue_free()

func _on_timer_timeout():
	finish()
	pass # Replace with function body.
