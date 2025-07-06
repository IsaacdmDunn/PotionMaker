extends Panel

var potionEffect: Effect
var potionRatio: float
var texture: Texture
func UpdateUI():
	#$HBoxContainer/EffectIcon.texture = texture
	$HBoxContainer/VBoxContainer/name.text = potionEffect.effectName
	$HBoxContainer/VBoxContainer/amount.text = str(potionEffect.strength) + " " +str(potionEffect.effectName)
	if potionEffect.baseDuration > 0:
		$HBoxContainer/VBoxContainer/amount.text += " per second for " + str(potionEffect.baseDuration) + " seconds"
