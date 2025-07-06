extends Panel
var inventorySlotID = 2
var inventory
var slotData
func _ready() -> void:
	inventory = get_tree().get_first_node_in_group("PlayerInventory")
	#slotData = inventory.get_child(1).get_child(inventorySlotID)

func _on_add_to_cauldron_pressed() -> void:
	if slotData != null  and slotData.amount > 0:
		slotData.amount -= 1
		inventory.application.AddIngredient(slotData.itemData.content)
	else:
		$VBoxContainer/HBoxContainer/AddToCauldron.disabled = true
	pass # Replace with function body.

func _process(delta: float) -> void:
	slotData = inventory.get_child(0).get_child(1).get_child(inventorySlotID) 
	UpdateUI()
	if slotData.amount < 1:
		queue_free()
	
func UpdateUI():
	if slotData != null and slotData.amount > 0:
		$VBoxContainer/HBoxContainer/TextureRect.texture = slotData.itemData.texture
		$VBoxContainer/HBoxContainer/name.text = slotData.itemData.itemName
		$VBoxContainer/HBoxContainer/amount.text = str(slotData.amount)
		
		#effects list here
