extends Node

enum PotionEffects {None,InstantHealth, InstantMana, InstantStamina}
var potionMixers: Array[PotionMixer]

enum UIState{None, Inventory, Cauldron}
var currentUIState: UIState = UIState.None
var UIStateChanged = false
var inventoryUI: Control
func _init() -> void:
	
	LoadAllFromFile("res://Resources/Mixers/", potionMixers)
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("inventory"):
		UIStateChanged = true
		if currentUIState != UIState.Inventory:
			currentUIState = UIState.Inventory
		else:
			currentUIState = UIState.None
			
func _ready() -> void:
	inventoryUI = get_tree().get_first_node_in_group("InventoryUI")
	
func _process(delta: float) -> void:
	if UIStateChanged:
		UIStateChanged = false
		if currentUIState == UIState.None:
			inventoryUI.position.y = -2000
		elif currentUIState == UIState.Inventory:
			inventoryUI.position.y = 173
			
#loads all resources from folder
func LoadAllFromFile(path, array):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				
				print("Found directory: " + file_name)
			else:
				array.append(load(path + file_name))
				print("Found file: " + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	pass
