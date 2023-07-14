extends TabBar


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func disable(do_it):
	for x in range(0,3):
		print(x)
		set_tab_disabled(x, do_it) 
