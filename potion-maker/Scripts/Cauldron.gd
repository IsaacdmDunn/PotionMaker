extends Node

@export var potionData: PotionData

@export var mixRate: float = .1
@export var potionRemovalThreshold: float = .01
@export var ingredientToAdd: Ingredient
var potionExported: Array[PotionData]
var temp = 15
var age = 0
var isStirring = false
var totalAmount = 1
var mixTimer = 0

#func _init() -> void:
	#potionData = PotionData.new()
	

func _process(delta: float) -> void:
	#if $".".position.distance_to($"../Player".position) < 10:
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	totalAmount = 0
	#removes liquids below a threshold
	for liquid in potionData.liquidList.size():
		totalAmount += potionData.liquidListAmount[liquid]
		if potionData.liquidListAmount[liquid] < potionRemovalThreshold:
			
			RemoveLiquid(potionData.liquidList[liquid], liquid)
			break
	
	mixPotion(delta)
	
	if Input.is_action_just_pressed("MakePotion"):
		MakePotion()
	if Input.is_action_just_pressed("AddTestIngredient"):
		AddIngredient(ingredientToAdd,1)
	
func SetPotionColour():
	var potionSize = 0
	var newColour = Color.BLACK
	for potionID in potionData.liquidList.size():
		potionSize += potionData.liquidListAmount[potionID]
		newColour += potionData.liquidList[potionID].colour * potionData.liquidListAmount[potionID]
		
	newColour.r = newColour.r / potionSize
	newColour.b = newColour.b / potionSize
	newColour.g = newColour.g / potionSize
	newColour.a = newColour.a / potionSize
	$Sprite3D.texture.gradient.colors[0] = newColour
	
#checks and mix possible potion combinations
func mixPotion(delta):
	#mix cooldown
	mixTimer += delta
	if mixRate < mixTimer:
		mixTimer = 0
		#for each mixer
		for mixer in GameData.potionMixers:
			#returns [PotionMix, LiquidRequirements, LiquidRatio]
			var mixerInstructions = mixer.CheckMixPotion(potionData.liquidList,potionData.liquidListAmount, temp, isStirring, age)
			if mixerInstructions != null:
				#for each requirement
				for item in mixerInstructions[1].size():
					#remove liquid amount based on ratio
					potionData.liquidListAmount[potionData.liquidList.find(mixerInstructions[1][item])] -= mixerInstructions[2][item]
					
					#if new liquid exists add to existing
					if potionData.liquidList.has(mixerInstructions[0]):
						#add new lquid amount
						potionData.liquidListAmount[potionData.liquidList.find(mixerInstructions[0])] += mixerInstructions[2][item]
						pass
					#if new liquid does not exists add to liquid list
					else:
						potionData.liquidList.append(mixerInstructions[0])
						potionData.liquidListAmount.append(mixerInstructions[2][item])
		SetPotionColour()

#make poition from mixture
func MakePotion():
	var potionToExport = PotionData.new()
	var potionVolume = 0
	var potionSize = 25
	
	for potionID in potionData.liquidList.size():
		potionVolume += potionData.liquidListAmount[potionID]
		
	if potionVolume+0.000001 >= potionSize: #add tiny extra to account for reoccuring number round error
		potionToExport.liquidList = potionData.liquidList
		for potionID in potionData.liquidList.size():
			var liquidRatio = (1/potionVolume) * potionData.liquidListAmount[potionID] * potionSize
			potionData.liquidListAmount[potionID] -= liquidRatio
			potionToExport.liquidListAmount.append(liquidRatio)
		
		
		print(potionData.liquidListAmount)
		potionExported.append(potionToExport)
		return potionToExport
	pass

func RemoveLiquid(liquid:Liquid, liquidID:int):
	
	potionData.liquidListAmount.remove_at(liquidID)
	potionData.liquidList.erase(liquid)

func AddLiquid(liquid:Liquid, amount: float):
	potionData.liquidList.append(liquid)
	potionData.liquidListAmount.append(amount)
	
func AddIngredient(ingredient: Ingredient, itemCount: int):
	if potionData.liquidList.has(ingredient.liquid):
		print("guh")
		potionData.liquidListAmount[potionData.liquidList.find(ingredient.liquid)] += ingredient.liquidAmount * itemCount
	else:
		print("huh")
		AddLiquid(ingredient.liquid, ingredient.liquidAmount)
