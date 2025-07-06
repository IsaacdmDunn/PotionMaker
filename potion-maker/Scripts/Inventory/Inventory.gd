extends Node
var slotPrefab = preload("res://Prefabs/UI/Inventory/inventory_slot.tscn")
var toolbarSlot = preload("res://Prefabs/UI/Inventory/toolbarSlot.tscn")
@export var maxSlotCount: int
@export var items: Array[Item]
var application
var optionButtionOnSlotID = -1
var mouseEntered = false
func _init() -> void:
	add_to_group("PlayerInventory")
	
func _ready() -> void:
	application = $"../Cauldron"
	for i in maxSlotCount:
		var slotToAdd = slotPrefab.instantiate()
		slotToAdd.slotID = i
		items.append(null)
		$Inventory/GridContainer.add_child(slotToAdd)
	for j in 9:
		var slotToAdd = toolbarSlot.instantiate()
		slotToAdd.slotID = j + maxSlotCount
		$Toolbar.add_child(slotToAdd)
	$CauldronUI.CreateInventoryUI()
	
func _process(delta: float) -> void:
	$CauldronUI.CauldronUI()
	for i in $Inventory/GridContainer.get_children().size():
		if items[i] != null:
			items[i].amount = $Inventory/GridContainer.get_child(i).amount
	pass

#checks if inventory can store an item if cant -1 if can but non-fullstack does not currentlu exist 0 and if stack exists and can store 1
func CheckIfItemCanStore(itemToStore: Item, amount: int):
	for item in items.size():
		if items[item] != null:
			if items[item].content == itemToStore.content:
				if $Inventory/GridContainer.get_child(item).amount + amount <= items[item].maxStack:
					
					$Inventory/GridContainer.get_child(item).amount += amount
					items[item].amount = $Inventory/GridContainer.get_child(item).amount
					$Inventory/GridContainer.get_child(item).UpdateUI()
					
					return 1
					
	for itemID in items.size():
		if items[itemID] == null:
			items[itemID] = itemToStore
			var itemToUpdate = $Inventory/GridContainer.get_child(itemID)
			itemToUpdate.itemData = itemToStore
			itemToUpdate.amount += amount
			itemToUpdate.UpdateUI()
			itemToUpdate.DisplayItemInfo()
			#rint(item2)
			return 1
	return 0
	
#creates a dropped item
func DropItem(slotID: int, amount: int):
	if application != null:
		AddToCauldron(slotID, amount)
	if $Inventory/GridContainer.get_child(slotID).amount > 0:
		$Inventory/GridContainer.get_child(slotID).amount -= amount
		get_tree().get_first_node_in_group("InventoryPayload").queue_free()
		#create dropped item
		print("drop")
	pass

func AddToCauldron(slotID: int, amount: int):
	if $Inventory/GridContainer.get_child(slotID).itemData.tag == "Ingredient":
		application.AddLiquid($Inventory/GridContainer.get_child(slotID).itemData.content.liquid, $Inventory/GridContainer.get_child(slotID).itemData.content.liquidAmount * amount)
	pass

func _on_inventory_mouse_entered() -> void:
	mouseEntered = true
	pass # Replace with function body.


func _on_inventory_mouse_exited() -> void:
	mouseEntered = false
	pass # Replace with function body.
