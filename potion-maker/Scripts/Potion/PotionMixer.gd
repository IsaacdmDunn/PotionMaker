extends Resource
class_name PotionMixer

@export var PotionMix: Liquid
@export var LiquidRequirements: Array[Liquid]
@export var LiquidRatio: Array[float] #liquid cost per unit of mix
@export var tempRequirements: float = -500 #-500 defaults to no requirements value in celcius
@export var stirring: int = -1 #-1 default not required, 0 false and 1 true
@export var mixAge: float = -1 #-1 default not required age measured in hours
@export var tempRange = 10 # add on top of requirements to set max temp

#check potion can be mixed
func CheckMixPotion(liquidList: Array[Liquid], liquidListAmount: Array[float], temp: float, isStirring: int, age: float):
	var liquidCount = 0
	for liquidID in liquidList.size():
		var mixerLiquidID = LiquidRequirements.find(liquidList[liquidID])
		if mixerLiquidID != -1 and liquidListAmount[liquidID] >= LiquidRatio[mixerLiquidID]:
			if CheckSpecialConditions(temp, isStirring, age):
				liquidCount+=1
	if liquidCount == LiquidRequirements.size():
		return [PotionMix, LiquidRequirements, LiquidRatio]
	pass

#check if potion meets special conditions
func CheckSpecialConditions(temp: float, isStirring: int, age: float):
	if temp == -500 or (temp < tempRequirements - tempRange or temp > tempRequirements + tempRange):
		if stirring == -1 or isStirring == stirring:
			if mixAge == -1 or age > mixAge:
				return true
			return false
		return false		
	return false
	pass
