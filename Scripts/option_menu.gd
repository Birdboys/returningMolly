extends Control
@onready var music_slider = $bg/music_vol
@onready var music_button = $bg/music_vol/music_button
@onready var sound_button = $bg/sound_button
@onready var sound_slider = $bg/sound_vol
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_music_vol_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		var value = 1-event.position.y/music_slider.size.y
		music_slider.value = value*100
		#value = clicked_value  # Set the new value for the progress bar
		#emit_signal("value_changed", value)  # Emit the signal to notify the value changepass # Replace with function body.

func _on_sound_vol_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		var value = 1-event.position.y/sound_slider.size.y
		sound_slider.value = value*100
	pass # Replace with function body.

func _on_music_vol_value_changed(value):
	#print(linear_to_db(value/100))
	MusicPlayer.volume_db = linear_to_db(value/100) - 14
	pass # Replace with function body.

func _on_music_button_pressed():
	music_slider.value = 0
	pass # Replace with function body.

func _on_sound_button_pressed():
	sound_slider.value = 0
	pass # Replace with function body.

func _on_close_pressed():
	queue_free()
	PlayerData.in_options = false
	pass # Replace with function body.
	
func initialize(music_val, sound_val):
	music_slider.value = music_val
	sound_slider.value = sound_val
