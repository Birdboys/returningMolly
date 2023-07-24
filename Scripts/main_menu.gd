extends Control
@onready var returningto = $returningto
@onready var molly = $molly
@onready var credits = $credits
@onready var buttons = $buttons
@onready var amp = 18
@onready var speed = 3
@onready var time=0
var return_pos
var molly_pos
signal play_game
signal quit_game
# Called when the node enters the scene tree for the first time.
func _ready():
	return_pos = returningto.position
	molly_pos = molly.position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta * speed
	var offset_val = Vector2(0, sin(time)) * amp - Vector2(0,amp/2)
	returningto.position = return_pos+offset_val
	molly.position = molly_pos+offset_val
	pass


func _on_credits_meta_clicked(meta):
	print(str(meta))
	OS.shell_open(str(meta))


func _on_play_pressed():
	emit_signal("play_game")
	pass # Replace with function body.

func _on_quit_pressed():
	emit_signal("quit_game")
	pass # Replace with function body.
