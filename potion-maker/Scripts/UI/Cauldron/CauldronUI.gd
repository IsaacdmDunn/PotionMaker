extends Panel

var CauldronInventoryOption = preload("res://Prefabs/UI/Cauldron/CauldronInventoryUI.tscn")
var CauldronEffectUI = preload("res://Prefabs/UI/Cauldron/PotionEffectCauldronUI.tscn")

var cauldron
var potionTooltips : Array[String]

var potionTooltipUpdate = false
func _init() -> void:
	add_to_group("CauldronUI")
	#CauldronUI()
	#CreateInventoryUI()

#func _ready() -> void:
	#EffectsUI()
func UpdateGraph():
	
	var potionBar = $VBoxContainer/HBoxContainer/PotionDataUI/VBoxContainer/PotionGraph/TextureRect2
	#print(cauldron.potionData.liquidListAmount)
	potionBar.texture.gradient.add_point(1, Color.WHITE)
	potionTooltips.clear()
	for points in potionBar.texture.gradient.get_point_count() - 1:
		potionBar.texture.gradient.remove_point(0)
	#print(potionBar.texture.gradient.offsets)
	#print(potionBar.texture.gradient.colors)
	if cauldron.totalAmount != 0:
		var totalAmountRatio = 1/cauldron.totalAmount
		if cauldron.potionData != null:
			var progress = 0
			for potionID in cauldron.potionData.liquidList.size():
				potionBar.texture.gradient.add_point(progress, cauldron.potionData.liquidList[potionID].colour)
				
				progress += cauldron.potionData.liquidListAmount[potionID] * totalAmountRatio
	
	
	
	if potionTooltipUpdate:
		var graph = $VBoxContainer/HBoxContainer/PotionDataUI/VBoxContainer/PotionGraph/TextureRect2
		var relativeMousePos = get_global_mouse_position().x - graph.position.x
		var normalisedMousePosX = (1/  graph.size.x) * relativeMousePos - 1.277
		var currentlyHoverID = 0
		
		for i in graph.texture.gradient.get_point_count() - 1:
			if cauldron.potionData.liquidList[i].effect != null:
				potionTooltips.append(cauldron.potionData.liquidList[i].effect.effectName + " " + str(cauldron.potionData.liquidListAmount[i]) + "ml") 
			else:
				potionTooltips.append("No Effect " + str(cauldron.potionData.liquidListAmount[i]) + "ml")
			if graph.texture.gradient.get_offset(i) < normalisedMousePosX:
				currentlyHoverID = i
				#break
		if potionTooltips.size() > 0:
			graph.tooltip_text = potionTooltips[currentlyHoverID]
			
func CreateInventoryUI():
	#for ui in $VBoxContainer/HBoxContainer/IngridientUI/VBoxContainer/ScrollContainer/VBoxContainer.get_children():
		#ui.queue_free()
	for i in $"../Inventory/GridContainer".get_children().size():
		if $"../Inventory/GridContainer".get_child(i).itemData != null:
			if $"../Inventory/GridContainer".get_child(i).itemData.tag == "Ingredient":
				var UIToAdd = CauldronInventoryOption.instantiate()
				UIToAdd.inventorySlotID = i
				$VBoxContainer/HBoxContainer/IngridientUI/VBoxContainer/ScrollContainer/VBoxContainer.add_child(UIToAdd)
	pass

func EffectsUI():
	for UI in $VBoxContainer/HBoxContainer/EffectsUI/VBoxContainer/ScrollContainer/VBoxContainer.get_children():
		UI.queue_free()
	
	
	for liquidID in cauldron.potionData.liquidList.size():
		if cauldron.potionData.liquidList[liquidID].effect != null:
			var UIToAdd = CauldronEffectUI.instantiate()
			UIToAdd.potionEffect = cauldron.potionData.liquidList[liquidID].effect
			UIToAdd.potionRatio = cauldron.potionData.liquidListAmount[liquidID]
			UIToAdd.UpdateUI()
			$VBoxContainer/HBoxContainer/EffectsUI/VBoxContainer/ScrollContainer/VBoxContainer.add_child(UIToAdd)
		pass
	
	pass
	
func CauldronUI():
	cauldron = $"..".application
	EffectsUI()
	
	
	#potionBar.texture.gradient.add_point(1, Color.WHITE)
	UpdateGraph()
	pass


func _on_texture_rect_2_mouse_entered() -> void:
	potionTooltipUpdate = true
	pass # Replace with function body.


func _on_texture_rect_2_mouse_exited() -> void:
	potionTooltipUpdate = false
	pass # Replace with function body.


func _on_make_potion_button_down() -> void:
	
	var potionToCreate:Item = load("res://Resources/Items/CustomPotion.tres").duplicate()
	var potionData = cauldron.MakePotion()
	
	if potionData != null:
		potionData.potionColour = cauldron.get_child(0).texture.gradient.colors[0]
		potionToCreate.content = potionData
		$"..".CheckIfItemCanStore(potionToCreate, 1)
	pass # Replace with function body.
