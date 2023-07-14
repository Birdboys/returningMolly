extends Node2D
@onready var itemImage = $itemTexture
var item_name
var item_id
var item_coords
var item_desc
var held = true
var item_location = null
var item_size
var pickup_coords
signal cursor_entered_item(me)
signal cursor_exited_item(me)
signal return_to_ground(me)
signal rotated()
# Called when the node enters the scene tree for the first time.
func _ready():
	loadItem(2)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if held:
		global_position = lerp(global_position,get_global_mouse_position(),1)
		if Input.is_action_just_pressed("ui_right_input"):
			rotateMe()
	pass

func loadItem(id, scl=Vector2(1,1)):
	itemImage.texture = await load("res://Assets/%s.png" % id)
	#itemImage.pivot_offset = itemImage.size/2*scl
	itemImage.scale = scl
	#print("THE PIVOT OFFSET",itemImage.pivot_offset, itemImage.size)
	item_id = id
	item_name = ItemLoader.item_data[str(id)]["item_name"]
	item_coords = ItemLoader.item_data[str(id)]["item_graph"]
	item_size = ItemLoader.item_data[str(id)]["item_size"]
	
func pickUp():
	pickup_coords = global_position
	z_index = 1
	held = true
func putDown(snap_coords=null):
	z_index = 0
	held = false
	if snap_coords:
		global_position = snap_coords + itemImage.size/2
	else:
		emit_signal("return_to_ground", item_id)
		queue_free()
	
func _on_item_texture_mouse_entered():
	#print("ENTERED ITEM")
	emit_signal("cursor_entered_item", self)
	pass # Replace with function body.


func _on_item_texture_mouse_exited():
	emit_signal("cursor_exited_item", self)
	pass # Replace with function body.

func rotateMe():
	return
	itemImage.pivot_offset = itemImage.size/2
	item_size = Vector2(item_size.y, item_size.x)
	itemImage.rotation += deg_to_rad(90)
	if rad_to_deg(itemImage.rotation) >= 360:
		itemImage.rotation = 0
	for x in range(len(item_coords)):
		item_coords[x] = round(item_coords[x].rotated(PI/2))
		#item_coords[x].x = Math.round(item_coords[x].x, 0)
	emit_signal("rotated")

func getSize():
	return itemImage.size
