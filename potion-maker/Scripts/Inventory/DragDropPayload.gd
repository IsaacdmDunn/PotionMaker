extends Panel

@export var itemData: Item = null
var slotID: int
var amount: int = 0
var isInSlot = false
func _ready() -> void:
	add_to_group("InventoryPayload")
	$Label.text = str(amount)
	$TextureRect.texture = itemData.texture
	
func _process(delta: float) -> void:
	position = get_global_mouse_position()
	if Input.is_action_just_released("Select") and !isInSlot:
		if !get_parent().mouseEntered:
			get_parent().DropItem(slotID, amount)
		queue_free()
	
