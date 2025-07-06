extends Panel
var payloadPrefab = "res://Prefabs/UI/Inventory/DrapDropPayload.tscn"
@export var itemData: Item = null
var slotID: int
var amount: int = 0
var mouseEntered = false
var payloadCreated = false

func _ready() -> void:
	$"../../..".items[slotID] = itemData

func _process(delta: float) -> void:
	UpdateUI()
	OnPayloadEnter()
	
	if amount == 0:
		#print(itemData)
		itemData = null
		$"../../..".items[slotID] = null
		$TextureRect.texture = null
		$Label.text = ""
		$TextureRect.modulate = Color.WHITE
	pass
	
func _input(event: InputEvent) -> void:
	
	if mouseEntered and !payloadCreated and Input.is_action_just_pressed("Select"):
		CreatePayload()
	
	if mouseEntered and Input.is_action_just_pressed("MenuAlt"):
		$"../../..".optionButtionOnSlotID = slotID
	
	if itemData != null and $"../../..".application != null and Input.is_action_just_pressed("AddTestIngredient"):
		$"../../..".application.AddLiquid(itemData.content.liquid, itemData.content.liquidAmount)
func UpdateUI():
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
				var grid = $".."
				#if item slot is not empty
				if itemData != null:
					#if not max stack
					if payload.amount + amount <= itemData.maxStack:
						#if item matches
						if itemData.content == payload.itemData.content:
							
							grid.get_child(payload.slotID).amount -= payload.amount
							amount += payload.amount
							
				#if item slot is empty	
				else:
					itemData = payload.itemData
					#grid.get_child(payload.slotID).itemData = null
					if slotID < $"../../..".maxSlotCount:
						grid.get_child(payload.slotID).amount -= payload.amount
					amount += payload.amount
					
				payload.queue_free()
				#$"../../..".items[slotID] = itemData
				
				
func DisplayItemInfo():
	
	$"../../Tooltips/VBoxContainer/Description".text = itemData.discription
	$"../../Tooltips/VBoxContainer/HBoxContainer/TextureRect".texture = itemData.texture
	$"../../Tooltips/VBoxContainer/HBoxContainer/itemName".text = itemData.itemName
	pass
	
func CreatePayload():
	if itemData != null and amount > 0:
		var prefabPayloadToSpawn = load(payloadPrefab)
		prefabPayloadToSpawn = prefabPayloadToSpawn.instantiate()
		prefabPayloadToSpawn.itemData = itemData
		prefabPayloadToSpawn.slotID = slotID
		if Input.is_action_pressed("sprint"):
			prefabPayloadToSpawn.amount = amount
		else:
			prefabPayloadToSpawn.amount = 1
		$"../../..".add_child(prefabPayloadToSpawn)
	payloadCreated = false
	pass

func _on_mouse_entered() -> void:
	mouseEntered = true
	if get_tree().get_nodes_in_group("InventoryPayload").size() > 0:
		get_tree().get_first_node_in_group("InventoryPayload").isInSlot = true
	
	if itemData != null:
		
		DisplayItemInfo()
	pass # Replace with function body.



func _on_mouse_exited() -> void:
	$"../../..".optionButtionOnSlotID = -1
	if get_tree().get_nodes_in_group("InventoryPayload").size() > 0:
		get_tree().get_first_node_in_group("InventoryPayload").isInSlot = false
	mouseEntered = false
	pass # Replace with function body.
