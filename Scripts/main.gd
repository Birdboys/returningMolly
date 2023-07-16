extends Control
@onready var dialogueScene = preload("res://Scenes/dialogue.tscn")
@onready var inventoryScene = preload("res://Scenes/inventory.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	var starting_dialogue = dialogueScene.instantiate()
	add_child(starting_dialogue)
	starting_dialogue.initialize("text0")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
