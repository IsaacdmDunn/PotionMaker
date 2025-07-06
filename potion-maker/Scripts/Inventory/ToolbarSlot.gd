extends Panel

var payloadPrefab = "res://Prefabs/UI/Inventory/DrapDropPayload.tscn"
@export var itemData: Item = null
var slotID: int
var amount: int = 0
var mouseEntered = false
var payloadCreated = false


func _process(delta: float) -> void:
	if itemData!= null:
		UpdateUI()
	OnPayloadEnter()
	
	if amount == 0:
		itemData = null
		$TextureRect.texture = null
		$Label.text = ""
		$TextureRect.modulate = Color.WHITE
	pass
	
func _input(event: InputEvent) -> void:
	pass


func SetPrioritySlot(inventorySlotID):
	slotID = inventorySlotID
	if $"../../Inventory/GridContainer".get_child(slotID).itemData != null:
		itemData = $"../../Inventory/GridContainer".get_child(slotID).itemData
		amount += $"../../Inventory/GridContainer".get_child(slotID).amount

func UpdateUI():
	itemData = $"../../Inventory/GridContainer".get_child(slotID).itemData
	amount = $"../../Inventory/GridContainer".get_child(slotID).amount
	if itemData != null:
		$Label.text = str(amount)
		$TextureRect.texture = itemData.texture
		if itemData.tag == "Potion":
			$TextureRect.modulate = itemData.content.potionColour
	pass
	
#when payload is dragged into slot if slot is empty take payload data else swap slot positions with payload origin
func OnPayloadEnter():
	var payload = get_tree().get_first_node_in_group("InventoryPayload")
	
	if mouseEntered:
		#if payload exists
		if get_tree().get_nodes_in_group("InventoryPayload").size() > 0:
			#drop
			if Input.is_action_just_released("Select"):
				slotID = payload.slotID
				#if item slot is not empty
				if itemData != null:
					#if not max stack
					if payload.amount + amount <= itemData.maxStack:
						#if item matches
						if itemData.content == payload.itemData.content:
							
							amount += payload.amount
							
				#if item slot is empty	
				else:
					itemData = payload.itemData
					amount += payload.amount
					
				payload.queue_free()
				
				UpdateUI()
	


func _on_mouse_entered() -> void:
	mouseEntered = true
	if get_tree().get_nodes_in_group("InventoryPayload").size() > 0:
		get_tree().get_first_node_in_group("InventoryPayload").isInSlot = true

	pass # Replace with function body.



func _on_mouse_exited() -> void:
	if get_tree().get_nodes_in_group("InventoryPayload").size() > 0:
		get_tree().get_first_node_in_group("InventoryPayload").isInSlot = false
	mouseEntered = false
	pass # Replace with function body.
