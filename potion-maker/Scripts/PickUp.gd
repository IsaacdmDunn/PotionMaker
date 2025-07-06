extends Node

@export var pickupItem: Item
var mouseEntered = false
@export var amount = 1


func _process(delta: float) -> void:
	if mouseEntered and Input.is_action_pressed("Select"):
		Pickup()
		
		
	pass

func _on_area_3d_mouse_entered() -> void:
	mouseEntered = true
	pass # Replace with function body.
	
		
func Pickup():
	var inventory = get_tree().get_first_node_in_group("PlayerInventory")
	var inventoryStatus = inventory.CheckIfItemCanStore(pickupItem, amount)
	#inv full do nothing
	if inventoryStatus == 0:
		pass
	#item added
	elif inventoryStatus == 1:
		#queue_free()
		pass


func _on_area_3d_mouse_exited() -> void:
	mouseEntered = false
	pass # Replace with function body.
